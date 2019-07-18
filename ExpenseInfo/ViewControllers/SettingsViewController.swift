

import UIKit

/// Settings ViewController to set the default values to the current Application
class SettingsViewController: UIViewController {
    
    /// expensBtn that executes your custom code in response to user interactions.
    @IBOutlet weak var expensBtn: UIButton! {
        didSet {
            expensBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            expensBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            expensBtn.layer.shadowOpacity = 1.0
            expensBtn.layer.shadowRadius = 10.0
            expensBtn.layer.masksToBounds = false
        }
    }
    
    /// Designable snapBtn that executes your custom code in response to user interactions.
    @IBOutlet weak var snapBtn: RoundButton! {
        didSet {
            
            snapBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            snapBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            snapBtn.layer.shadowOpacity = 1.0
            snapBtn.layer.shadowRadius = 10.0
            snapBtn.layer.masksToBounds = false
        }
    }
    
    /// Designable menuButton that executes your custom code in response to user interactions.
    @IBOutlet weak var menuButton: RoundButton! {
        didSet {
            menuButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            menuButton.layer.shadowOffset = CGSize(width: 0, height: 3)
            menuButton.layer.shadowOpacity = 1.0
            menuButton.layer.shadowRadius = 10.0
            menuButton.layer.masksToBounds = false
        }
    }
    
    /// enterBillBtn that executes your custom code in response to user interactions.
    @IBOutlet weak var enterBillBtn: UIButton! {
        didSet {
            enterBillBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            enterBillBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            enterBillBtn.layer.shadowOpacity = 1.0
            enterBillBtn.layer.shadowRadius = 10.0
            enterBillBtn.layer.masksToBounds = false
        }
    }
    
    /// settingsBtn that executes your custom code in response to user interactions.
    @IBOutlet weak var settingsBtn: UIButton! {
        didSet {
            settingsBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            settingsBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            settingsBtn.layer.shadowOpacity = 1.0
            settingsBtn.layer.shadowRadius = 10.0
            settingsBtn.layer.masksToBounds = false
        }
    }
    
    /// uploadBtn that executes your custom code in response to user interactions.
    @IBOutlet weak var uploadBtn: UIButton! {
        didSet {
            uploadBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            uploadBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            uploadBtn.layer.shadowOpacity = 1.0
            uploadBtn.layer.shadowRadius = 10.0
            uploadBtn.layer.masksToBounds = false
        }
    }
    
    /// reportBtn that executes your custom code in response to user interactions.
    @IBOutlet weak var reportBtn: UIButton! {
        didSet {
            reportBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            reportBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            reportBtn.layer.shadowOpacity = 1.0
            reportBtn.layer.shadowRadius = 10.0
            reportBtn.layer.masksToBounds = false
        }
    }
    
    /// reimbursementBtn that executes your custom code in response to user interactions.
    @IBOutlet weak var reimbursementBtn: UIButton! {
        didSet {
            reimbursementBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            reimbursementBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            reimbursementBtn.layer.shadowOpacity = 1.0
            reimbursementBtn.layer.shadowRadius = 10.0
            reimbursementBtn.layer.masksToBounds = false
        }
    }

    /// Perform set Currency trigger
    ///
    /// - Parameter sender: sender UIButton
    @IBAction func setCurrencyAction(_ sender: UIButton) {
        setCurrency()
    }

    /// Hide Options Menu
    func hideMenu() {
        self.shadowView.isHidden = true
        self.optionsView.isHidden = true
    }
    
    /// This method navigates to the HomeViewController
    ///
    /// - Parameter sender: sender UIButton
    @IBAction func goHoem(_ sender: UIButton) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier:AppConstants.Segue.Identifier.HomeViewController) as? HomeViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    
    /// Show Options Menu
    func showMenu() {
        
        
        self.shadowView.isHidden = false
        self.optionsView.isHidden = false
        
    }
    
    /// stack1 an interface for laying out a collection of views in either a column or a row.
    @IBOutlet weak var stack1: UIStackView!
    
    /// stack2 an interface for laying out a collection of views in either a column or a row.
    @IBOutlet weak var stack2: UIStackView!
    
    /// Check for the option menus is active
    var isMenuActive = false

    /// optionsView that manages the content for a rectangular area on the screen.
    @IBOutlet weak var optionsView: UIView!
    
    /// shadowView that manages the content for a rectangular area on the screen.
    @IBOutlet weak var shadowView: UIView!
    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    ///
    /// - Parameter animated: If true, the disappearance of the view is being animated.

    override func viewWillDisappear(_ animated: Bool) {
        self.stack1.isHidden = false
        self.stack2.isHidden = false
        menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
        hideMenu()
        
        isMenuActive = false
    }
    
    /// When menu is pressed from the bottom bar it opens the optionsView and should change the value of isMenuActive Value
    ///
    /// - Parameter sender: menuButton id
    @IBAction func menuButtonAction(_ sender: UIButton) {
        
        if isMenuActive {
//            self.stack1.isHidden = false
//            self.stack2.isHidden = false
            menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
            hideMenu()
            
//            isMenuActive = false
        } else {
//            self.stack1.isHidden = true
//            self.stack2.isHidden = true
            menuButton.setImage(UIImage(named: "retakeButton"), for: .normal)
            
            self.showMenu()
//            isMenuActive = true
        }
        self.stack1.isHidden = isMenuActive ? false : true
        self.stack2.isHidden = isMenuActive ? false : true
        isMenuActive = isMenuActive ? false : true

    }
    

    @IBOutlet weak var passwordLbl: UILabel!
    
    /// When this manual Entry is pressed , it updates the AddExpenseType Defaults and navigate to MainViewController
    ///
    /// - Parameter sender: sender id
    @IBAction func manualEntry(_ sender: UIButton) {
        UserDefaults.standard.set("Manual", forKey: AppConstants.Defaults.Key.AddExpenseType)
        
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.MainViewController) as? MainViewController
        self.present(firstVC!, animated: true, completion: nil)
        
    }
    
    /// When this upload bill is pressed , it updates the AddExpenseType Defaults and navigate to UploadViewController
    ///
    /// - Parameter sender: sender id
    @IBAction func uploadBill(_ sender: UIButton) {
        
        UserDefaults.standard.set("Upload", forKey: AppConstants.Defaults.Key.AddExpenseType)
        
        
        
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.UploadViewController) as? UploadViewController
        self.present(firstVC!, animated: true, completion: nil)
        
    }
    
    /// When this snap bill is pressed , it updates the AddExpenseType Defaults and navigate to ScannerViewController
    ///
    /// - Parameter sender: sender id
    @IBAction func snapBill(_ sender: UIButton) {
        UserDefaults.standard.set("Snap", forKey: AppConstants.Defaults.Key.AddExpenseType)
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ScannerViewController) as? ScannerViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    
    /// Displays the Currency Name
    @IBOutlet weak var currency: UILabel!
    
    /// This method is used to present the currency PickerView
    func setCurrency() {
        let alert = UIAlertController(title: "Currencies", message: "", preferredStyle: AppConstants.alertActionStyle
        )
        
        
        alert.addLocalePicker(type: .currency) { info in
            alert.title = info?.currencyCode
            alert.message = "is selected"
            print("==========> \(String(describing: info?.currencySymbol))")
            self.currency.text = "\(info!.currencySymbol!) \(info!.currencyCode!)"
            UserDefaults.standard.set(info!.currencySymbol!, forKey: AppConstants.Defaults.Key.CurrencySymbol)
            UserDefaults.standard.set(info!.currencyCode!, forKey: AppConstants.Defaults.Key.CurrencyCode)
            
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    /// Called after the controller's view is loaded into memory.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        if let currencyCode = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.CurrencyCode) {
            if let currencySymbol = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.CurrencySymbol) {
                self.currency.text = "\(currencySymbol) \(currencyCode)"
            }
        }
        
    }
    
    
    
    
}
