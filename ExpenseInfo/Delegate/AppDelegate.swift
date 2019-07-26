
import UIKit
import CoreData
import Firebase
//import UXCam
/// The delegate of the currently running `UIApplication` instance.

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    /// The backdrop for your app’s user interface and the object that dispatches events to your views.
    var window: UIWindow?
    
    /**
     Tells the delegate that the launch process is almost done and the app is almost ready to run.
     
     - Parameter application: The singleton app object.
     - Parameter launchOptions: A dictionary indicating the reason the app was launched (if any). The contents of this dictionary may be empty in situations where the user launched the app directly. For information about the possible keys in this dictionary and how to handle them, see Launch Options Keys.
     - Returns: false if the app cannot handle the URL resource or continue a user activity, otherwise return true. The return value is ignored if the app is launched as a result of a remote notification.
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //         UXCam.start(withKey:"f8yeuovv43jf9kb")
        
        FirebaseApp.configure()
        
        
        
        let now = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        UserDefaults.standard.set(year, forKey: AppConstants.Defaults.Key.Year)
        UserDefaults.standard.set(nameOfMonth, forKey: AppConstants.Defaults.Key.Month)
        
        
        let currentLocale = NSLocale.current as NSLocale // get the current locale.
        let currencySymbol = currentLocale.object(forKey: .currencySymbol) as? String
        let currencyCode = currentLocale.object(forKey: .currencyCode) as? String
        
        
        if UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.CurrencySymbol) == nil {
            UserDefaults.standard.set(currencySymbol!, forKey: AppConstants.Defaults.Key.CurrencySymbol)
        }
        
        if UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.CurrencyCode) == nil {
            UserDefaults.standard.set(currencyCode!, forKey: AppConstants.Defaults.Key.CurrencyCode)
        }
        return true
    }
    /**
     Tells the delegate that the app is about to become inactive.
     
     - Parameter application: The singleton app object.
     */
    /// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    /// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    /**
     Tells the delegate that the app is now in the background.
     
     - Parameter application: The singleton app object.
     */
    /// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    /// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    /**
     Tells the delegate that the app is about to enter the foreground.
     
     - Parameter application: The singleton app object.
     */
    /// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    /**
     Tells the delegate that the app has become active.
     
     - Parameter application: The singleton app object.
     */
    /// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    
    /**
     Tells the delegate when the app is about to terminate.
     
     - Parameter application: The singleton app object.
     */
    /// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    /// Saves changes in the application's managed object context before the application terminates.
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    /**
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     - Returns: `NSPersistentContainer` instance
     */
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ExpenseInfo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    /**
     when the context has changes , it leads to save the context
     
     */
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

