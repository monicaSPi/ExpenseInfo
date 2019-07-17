import UIKit

// MARK: - UIApplication
extension UIApplication {
    
    /// This method is called when the uiviewcontroller is inserted to uialertviewcontroller
    ///
    /// - Parameter viewController: view controller with root viewcontroller arrow pointing in the storyboard
    /// - Returns: appropriate viewcontroller
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        return viewController
    }
}
