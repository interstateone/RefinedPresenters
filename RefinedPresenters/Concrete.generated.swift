// Generated using Sourcery 0.7.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// MARK: - Concrete wrapper for ExampleNavigator

final class ConcreteExampleNavigator: ExampleNavigator {
    private let concrete: ExampleNavigator

    init(_ concrete: ExampleNavigator) {
        self.concrete = concrete
    }

    func presentAlert(title: String?, message: String) -> Void {
        return concrete.presentAlert(title: title,message: message)
    }

}

// MARK: - Concrete wrapper for ExampleView, but holds an unowned reference

final class UnownedConcreteExampleView: ExampleView {
    private unowned var concrete: ExampleView

    init(_ concrete: ExampleView) {
        self.concrete = concrete
    }

    func wait() -> Void {
        return concrete.wait()
    }
    func stopWaiting() -> Void {
        return concrete.stopWaiting()
    }

    var model: ExampleViewModel? {
        get { return concrete.model }
        set { concrete.model = newValue }
    }
}
