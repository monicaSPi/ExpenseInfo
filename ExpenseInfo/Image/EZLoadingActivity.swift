//
//  EZLoadingActivity.swift
//  EZLoadingActivity
//
//  Created by Goktug Yilmaz on 02/06/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

import UIKit

/// <#Description#>
public struct EZLoadingActivity {
    
    /// <#Description#>
    public struct Settings {
        
        /// <#Description#>
        public static var BackgroundColor = UIColor(red: 227/255, green: 232/255, blue: 235/255, alpha: 1.0)
        
        /// <#Description#>
        public static var ActivityColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        
        /// <#Description#>
        public static var TextColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1.0)
        
        /// <#Description#>
        public static var FontName = "HelveticaNeue-Light"
        // Other possible stuff: ✓ ✓ ✔︎ ✕ ✖︎ ✘
        
        /// <#Description#>
        public static var SuccessIcon = "✔︎"
        
        /// <#Description#>
        public static var FailIcon = "✘"
        
        /// <#Description#>
        public static var SuccessText = "Success"
        
        /// <#Description#>
        public static var FailText = "Failure"
        
        /// <#Description#>
        public static var SuccessColor = UIColor(red: 68/255, green: 118/255, blue: 4/255, alpha: 1.0)
        
        /// <#Description#>
        public static var FailColor = UIColor(red: 255/255, green: 75/255, blue: 56/255, alpha: 1.0)
        
        /// <#Description#>
        public static var ActivityWidth = UIScreen.ScreenWidth / Settings.WidthDivision
        
        /// <#Description#>
        public static var ActivityHeight = ActivityWidth / 3
        
        /// <#Description#>
        public static var ShadowEnabled = true
        
        /// <#Description#>
        public static var WidthDivision: CGFloat {
            get {
                if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                    return  3.5
                } else {
                    return 1.6
                }
            }
        }
        
        /// <#Description#>
        public static var LoadOverApplicationWindow = false
        
        /// <#Description#>
        public static var DarkensBackground = false
    }
    
    /// <#Description#>
    fileprivate static var instance: LoadingActivity?
    
    /// <#Description#>
    fileprivate static var hidingInProgress = false
    
    /// <#Description#>
    fileprivate static var overlay: UIView!
    
    /// Disable UI stops users touch actions until EZLoadingActivity is hidden. Return success status
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - text: <#text description#>
    ///   - disableUI: <#disableUI description#>
    /// - Returns: <#return value description#>
    @discardableResult
    public static func show(_ text: String, disableUI: Bool) -> Bool {
        guard instance == nil else {
            print("EZLoadingActivity: You still have an active activity, please stop that before creating a new one")
            return false
        }
        
        guard topMostController != nil else {
            print("EZLoadingActivity Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
            return false
        }
        // Separate creation from showing
        instance = LoadingActivity(text: text, disableUI: disableUI)
        DispatchQueue.main.async {
            if Settings.DarkensBackground {
                if overlay == nil {
                    overlay = UIView(frame: UIApplication.shared.keyWindow!.frame)
                }
                overlay.backgroundColor = UIColor.black.withAlphaComponent(0)
                topMostController?.view.addSubview(overlay)
                UIView.animate(withDuration: 0.2, animations: {overlay.backgroundColor = overlay.backgroundColor?.withAlphaComponent(0.5)})
            }
            instance?.showLoadingActivity()
        }
        return true
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - text: <#text description#>
    ///   - disableUI: <#disableUI description#>
    ///   - seconds: <#seconds description#>
    /// - Returns: <#return value description#>
    @discardableResult
    public static func showWithDelay(_ text: String, disableUI: Bool, seconds: Double) -> Bool {
        let showValue = show(text, disableUI: disableUI)
        delay(seconds) { () -> () in
            _ = hide(true, animated: false)
        }
        return showValue
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - text: <#text description#>
    ///   - disableUI: <#disableUI description#>
    ///   - controller: <#controller description#>
    /// - Returns: <#return value description#>
    public static func showOnController(_ text: String, disableUI: Bool, controller:UIViewController) -> Bool{
        guard instance == nil else {
            print("EZLoadingActivity: You still have an active activity, please stop that before creating a new one")
            return false
        }
        instance = LoadingActivity(text: text, disableUI: disableUI)
        DispatchQueue.main.async {
            instance?.showLoadingWithController(controller)
        }
        
        return true
    }
    
    /// Returns success status
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - success: <#success description#>
    ///   - animated: <#animated description#>
    /// - Returns: <#return value description#>
    @discardableResult
    public static func hide(_ success: Bool? = nil, animated: Bool = false) -> Bool {
        guard instance != nil else {
            print("EZLoadingActivity: You don't have an activity instance")
            return false
        }
        
        guard hidingInProgress == false else {
            print("EZLoadingActivity: Hiding already in progress")
            return false
        }
        
        if !Thread.current.isMainThread {
            DispatchQueue.main.async {
                instance?.hideLoadingActivity(success, animated: animated)
            }
        } else {
            instance?.hideLoadingActivity(success, animated: animated)
        }
        
        if overlay != nil {
            UIView.animate(withDuration: 0.2, animations: {
                overlay.backgroundColor = overlay.backgroundColor?.withAlphaComponent(0)
                }, completion: { _ in
                    overlay.removeFromSuperview()
            })
        }
        
        return true
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - seconds: <#seconds description#>
    ///   - after: <#after description#>
    fileprivate static func delay(_ seconds: Double, after: @escaping ()->()) {
        let queue = DispatchQueue.main
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
    }
    
    /// <#Description#>
    fileprivate class LoadingActivity: UIView {
        var textLabel: UILabel!
        var activityView: UIActivityIndicatorView!
        var icon: UILabel!
        var UIDisabled = false
        
        convenience init(text: String, disableUI: Bool) {
            self.init(frame: CGRect(x: 0, y: 0, width: Settings.ActivityWidth, height: Settings.ActivityHeight))
            center = CGPoint(x: topMostController!.view.bounds.midX, y: topMostController!.view.bounds.midY)
            autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
            backgroundColor = Settings.BackgroundColor
            alpha = 1
            layer.cornerRadius = 8
            if Settings.ShadowEnabled {
                createShadow()
            }
            
            let yPosition = frame.height/2 - 20
            
            activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            activityView.frame = CGRect(x: 10, y: yPosition, width: 40, height: 40)
            activityView.color = Settings.ActivityColor
            activityView.startAnimating()
            
            textLabel = UILabel(frame: CGRect(x: 60, y: yPosition, width: Settings.ActivityWidth - 70, height: 40))
            textLabel.textColor = Settings.TextColor
            textLabel.font = UIFont(name: Settings.FontName, size: 30)
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.minimumScaleFactor = 0.25
            textLabel.textAlignment = NSTextAlignment.center
            textLabel.text = text
            
            if disableUI {
                UIApplication.shared.beginIgnoringInteractionEvents()
                UIDisabled = true
            }
        }
        
        func showLoadingActivity() {
            addSubview(activityView)
            addSubview(textLabel)
            
            //make it smoothly
            self.alpha = 0
            
            if Settings.LoadOverApplicationWindow {
                UIApplication.shared.windows.first?.addSubview(self)
            } else {
                topMostController!.view.addSubview(self)
            }
            
            //make it smoothly
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1
            })
        }
        
        func showLoadingWithController(_ controller:UIViewController){
            addSubview(activityView)
            addSubview(textLabel)
            
            //make it smoothly
            self.alpha = 0
            controller.view.addSubview(self)
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1
            })
        }
        
        func createShadow() {
            layer.shadowPath = createShadowPath().cgPath
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowRadius = 5
            layer.shadowOpacity = 0.5
        }
        
        func createShadowPath() -> UIBezierPath {
            let myBezier = UIBezierPath()
            myBezier.move(to: CGPoint(x: -3, y: -3))
            myBezier.addLine(to: CGPoint(x: frame.width + 3, y: -3))
            myBezier.addLine(to: CGPoint(x: frame.width + 3, y: frame.height + 3))
            myBezier.addLine(to: CGPoint(x: -3, y: frame.height + 3))
            myBezier.close()
            return myBezier
        }
        
        func hideLoadingActivity(_ success: Bool?, animated: Bool) {
            hidingInProgress = true
            if UIDisabled {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            
            var animationDuration: Double = 0
            if success != nil {
                if success! {
                    animationDuration = 0.5
                } else {
                    animationDuration = 1
                }
            }
            
            icon = UILabel(frame: CGRect(x: 10, y: frame.height/2 - 20, width: 40, height: 40))
            icon.font = UIFont(name: Settings.FontName, size: 60)
            icon.textAlignment = NSTextAlignment.center
            
            if animated {
                textLabel.fadeTransition(animationDuration)
            }
            
            if success != nil {
                if success! {
                    icon.textColor = Settings.SuccessColor
                    icon.text = Settings.SuccessIcon
                    textLabel.text = Settings.SuccessText
                } else {
                    icon.textColor = Settings.FailColor
                    icon.text = Settings.FailIcon
                    textLabel.text = Settings.FailText
                }
            }
            
            addSubview(icon)
            
            if animated {
                icon.alpha = 0
                activityView.stopAnimating()
                UIView.animate(withDuration: animationDuration, animations: {
                    self.icon.alpha = 1
                    }, completion: { (value: Bool) in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.alpha = 0
                            }, completion: { (success) in
                                self.callSelectorAsync(#selector(UIView.removeFromSuperview), delay: animationDuration)
                        })
                        instance = nil
                        hidingInProgress = false
                })
            } else {
                activityView.stopAnimating()
                self.callSelectorAsync(#selector(UIView.removeFromSuperview), delay: animationDuration)
                instance = nil
                hidingInProgress = false
            }
        }
    }
}



// MARK: - NSObject
private extension NSObject {
    
    /// This method has the loop with timer added
    ///
    /// - Parameters:
    ///   - selector: <#selector description#>
    ///   - delay: <#delay description#>
    func callSelectorAsync(_ selector: Selector, delay: TimeInterval) {
        let timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: selector, userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
}

// MARK: - UIScreen
private extension UIScreen {
    
    /// This method gets the statusbar orientation of the current application
    class var Orientation: UIInterfaceOrientation {
        get {
            return UIApplication.shared.statusBarOrientation
        }
    }
    
    /// This variable has `UIScreen` width based on their orientation
    class var ScreenWidth: CGFloat {
        get {
            if (Orientation == UIInterfaceOrientation.portrait) {
                return UIScreen.main.bounds.size.width
            } else {
                return UIScreen.main.bounds.size.height
            }
        }
    }
    
  }

/// This method return the current uiviewcontroller
private var topMostController: UIViewController? {
    var presentedVC = UIApplication.shared.keyWindow?.rootViewController
    while let pVC = presentedVC?.presentedViewController {
        presentedVC = pVC
    }
    
    return presentedVC
}
