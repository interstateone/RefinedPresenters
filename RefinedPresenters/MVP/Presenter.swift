import Foundation
import PromiseKit

public protocol Presenter: class {
    // We use the UIViewController lifecycle method names now, but this is the basic idea
    func initializeView()
    func teardownView()
}

public protocol DataFetching: class {
    associatedtype Data
    var currentTask: CancellablePromise<Data>? { get set }

    func createTask() -> CancellablePromise<Data>
    func loadData()
    func preLoad()
    func postLoad()
    func dataDidLoad(data: Data)
    func dataFailedToLoad(error: Error)
}

public extension DataFetching {
    func preLoad() {}
    func postLoad() {}

    /// Template method that lays out the process of loading data
    public func loadData() {
        if let task = currentTask {
            task.cancel()
        }

        preLoad()

        let newTask = createTask()
        currentTask = newTask

        newTask
        .then(execute: dataDidLoad)
        .catch(execute: dataFailedToLoad)
        .always {
            self.currentTask = nil
            self.postLoad()
        }
    }
}

/// A refinement of Presenter for the common case where:
///  - it manages a single view
///  - it uses a single type of data
///  - it loads that data, potentially asynchronously
///
/// For this case, implementing FetchingPresenter means that the only work to be done is specifying what data to load (usually delegated to a Service) and how to transform the data for display in the View.
public protocol FetchingPresenter: Presenter, DataFetching {
    associatedtype View: WaitingView
    var view: View { get }
    associatedtype Wireframe: AlertPresenting
    var wireframe: Wireframe { get }
}

extension FetchingPresenter {
    // MARK: Default implementations that take advantage of the constraints on View and Wireframe

    public func initializeView() {
        loadData()
    }

    public func preLoad() {
        view.wait()
    }

    public func postLoad() {
        view.stopWaiting()
    }

    public func dataFailedToLoad(error: Error) {
        wireframe.presentAlert(title: "Error", message: error.localizedDescription)
    }
}
