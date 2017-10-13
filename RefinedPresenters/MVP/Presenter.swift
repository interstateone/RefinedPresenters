import Foundation
import PromiseKit

public protocol Presenter: class {
    // We use the UIViewController lifecycle method names now, but this is the basic idea
    func initializeView()
    func teardownView()
}

public protocol ValueFetching: class {
    associatedtype Value
    var currentTask: CancellablePromise<Value>? { get set }

    func createTask() -> CancellablePromise<Value>
    func fetchValue()
    func preFetch()
    func postFetch()
    func fetchedValue(_ value: Value)
    func failedToFetchValue(error: Error)
}

public extension ValueFetching {
    func preFetch() {}
    func postFetch() {}

    /// Template method that lays out the process of loading data
    public func fetchValue() {
        if let task = currentTask {
            task.cancel()
        }

        preFetch()

        let newTask = createTask()
        currentTask = newTask

        newTask
        .then(execute: fetchedValue)
        .catch(execute: failedToFetchValue)
        .always {
            self.currentTask = nil
            self.postFetch()
        }
    }
}

/// A refinement of Presenter for the common case where:
///  - it manages a single view
///  - it uses a single type of data
///  - it loads that data, potentially asynchronously
///
/// For this case, implementing FetchingPresenter means that the only work to be done is specifying what data to load (usually delegated to a Service) and how to transform the data for display in the View.
public protocol FetchingPresenter: Presenter, ValueFetching {
    associatedtype View: WaitingView
    var view: View { get }
    associatedtype Wireframe: AlertPresenting
    var wireframe: Wireframe { get }
}

extension FetchingPresenter {
    // MARK: Default implementations that take advantage of the constraints on View and Wireframe

    public func initializeView() {
        fetchValue()
    }

    public func preFetch() {
        view.wait()
    }

    public func postFetch() {
        view.stopWaiting()
    }

    public func failedToFetchValue(error: Error) {
        wireframe.presentAlert(title: "Error", message: error.localizedDescription)
    }
}
