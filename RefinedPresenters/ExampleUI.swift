import UIKit
import PromiseKit

// sourcery: UnownedConcrete
protocol ExampleView: WaitingView {
    var model: ExampleViewModel? { get set }
}

// sourcery: Concrete
protocol ExampleNavigator: AlertPresenting {
}

protocol ExampleViewDelegate: Presenter {
}

final class ExamplePresenter: FetchingPresenter, ExampleViewDelegate {
    // The need for concrete types here isn't because FetchingPresenter is a PAT, but because protocols don't conform to themselves, and so the ExampleView protocol doesn't satisfy FetchingPresenter.View's constraint that it's a WaitingView
    // It's not ideal that the presenter/view retain cycle is broken with an unowned reference. Unowned is technically correct because a presenter is kept alive by its view, although this is a little risky because there's nothing stopping something else from retaining it other than convention. This is a bigger downside than the necessity of the concrete wrapper itself. Preventing anything else from retaining a presenter by hiding its initialization during VC construction could prevent accidents
    typealias View = UnownedConcreteExampleView
    var view: View

    typealias Wireframe = ConcreteExampleNavigator
    let wireframe: Wireframe

    init(view: ExampleView, wireframe: ExampleNavigator) {
        self.view = UnownedConcreteExampleView(view)
        self.wireframe = ConcreteExampleNavigator(wireframe)
    }

    // MARK: Presenter

    func initializeView() {
        loadData()
    }

    func teardownView() {
        currentTask?.cancel()
        view.model = nil
    }

    // MARK: FetchingPresenter

    typealias Data = ExampleData

    var currentTask: CancellablePromise<ExampleData>?

    func createTask() -> CancellablePromise<ExampleData> {
        // Would normally use a service
        return CancellablePromise(value: ExampleData(name: "blorp"))
    }

    func fetchedValue(_ value: Value) {
        view.model = ExampleViewModel(value: value.name)
    }
}

final class ExampleViewController: UIViewController, ExampleView {
    @IBOutlet weak var label: UILabel!

    var delegate: ExampleViewDelegate?

    var model: ExampleViewModel? {
        didSet {
            label.text = model?.formattedValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.initializeView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.teardownView()
    }
}

struct ExampleData {
    let name: String
}

struct ExampleViewModel {
    let formattedValue: String
    init(value: String) {
        self.formattedValue = value.uppercased()
    }
}
