import UIKit

// MARK: - UIViewController Extension
extension UIViewController {
    
    /// This method is used to show a uiviewcontroller in an uialertcontroller
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
    }
}
