import Foundation

public protocol Wireframe {
}

public protocol AlertPresenting {
    func presentAlert(title: String?, message: String)
}

public class MainWireframe: Wireframe, AlertPresenting, ExampleNavigator {
    public func presentAlert(title: String?, message: String) {
    }
}
