import UIKit

public protocol View: class {
}

public protocol WaitingView: View {
    func wait()
    func stopWaiting()
}

extension UIViewController: WaitingView {
    public func wait() {
        // SVProgressHUD.show()
    }

    public func stopWaiting() {
        // SVProgressHUD.hide()
    }
}
