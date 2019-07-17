

import UIKit

/// <#Description#>
class SettingsViewController: UIViewController {
    
    /// <#Description#>
    @IBOutlet weak var expensBtn: UIButton! {
        didSet {
            expensBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            expensBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            expensBtn.layer.shadowOpacity = 1.0
            expensBtn.layer.shadowRadius = 10.0
            expensBtn.layer.masksToBounds = false
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var snapBtn: RoundButton! {
        didSet {
            
            snapBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            snapBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            snapBtn.layer.shadowOpacity = 1.0
            snapBtn.layer.shadowRadius = 10.0
            snapBtn.layer.masksToBounds = false
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var menuButton: RoundButton! {
        didSet {
            menuButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            menuButton.layer.shadowOffset = CGSize(width: 0, height: 3)
            menuButton.layer.shadowOpacity = 1.0
            menuButton.layer.shadowRadius = 10.0
            menuButton.layer.masksToBounds = false
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var enterBillBtn: UIButton! {
        didSet {
            enterBillBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            enterBillBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            enterBillBtn.layer.shadowOpacity = 1.0
            enterBillBtn.layer.shadowRadius = 10.0
            enterBillBtn.layer.masksToBounds = false
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var settingsBtn: UIButton! {
        didSet {
            settingsBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            settingsBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            settingsBtn.layer.shadowOpacity = 1.0
            settingsBtn.layer.shadowRadius = 10.0
            settingsBtn.layer.masksToBounds = false
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var uploadBtn: UIButton! {
        didSet {
            uploadBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            uploadBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            uploadBtn.layer.shadowOpacity = 1.0
            uploadBtn.layer.shadowRadius = 10.0
            uploadBtn.layer.masksToBounds = false
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var reportBtn: UIButton! {
        didSet {
            reportBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            reportBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            reportBtn.layer.shadowOpacity = 1.0
            reportBtn.layer.shadowRadius = 10.0
            reportBtn.layer.masksToBounds = false
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var reimbursementBtn: UIButton! {
        didSet {
            reimbursementBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            reimbursementBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            reimbursementBtn.layer.shadowOpacity = 1.0
            reimbursementBtn.layer.shadowRadius = 10.0
            reimbursementBtn.layer.masksToBounds = false
        }
    }

    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func setCurrencyAction(_ sender: UIButton) {
        setCurrency()
    }

    /// <#Description#>
    func hideMenu() {
        self.shadowView.isHidden = true
        self.optionsView.isHidden = true
    }
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func goHoem(_ sender: UIButton) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier:AppConstants.Segue.Identifier.HomeViewController) as? HomeViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    
    /// <#Description#>
    func showMenu() {
        
        
        self.shadowView.isHidden = false
        self.optionsView.isHidden = false
        
    }
    
    /// <#Description#>
    @IBOutlet weak var stack1: UIStackView!
    
    /// <#Description#>
    @IBOutlet weak var stack2: UIStackView!
    
    /// <#Description#>
    var isMenuActive = false

    /// <#Description#>
    @IBOutlet weak var optionsView: UIView!
    
    /// <#Description#>
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
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
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
    
    /// <#Description#>
    @IBOutlet weak var passwordLbl: UILabel!
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func manualEntry(_ sender: UIButton) {
        UserDefaults.standard.set("Manual", forKey: AppConstants.Defaults.Key.AddExpenseType)
        
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.MainViewController) as? MainViewController
        self.present(firstVC!, animated: true, completion: nil)
        
    }
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func uploadBill(_ sender: UIButton) {
        
        UserDefaults.standard.set("Upload", forKey: AppConstants.Defaults.Key.AddExpenseType)
        
        
        
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.UploadViewController) as? UploadViewController
        self.present(firstVC!, animated: true, completion: nil)
        
    }
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func snapBill(_ sender: UIButton) {
        UserDefaults.standard.set("Snap", forKey: AppConstants.Defaults.Key.AddExpenseType)
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ScannerViewController) as? ScannerViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
//    func setPassword() {
//        let alert = UIAlertController(title: "Password", message: "", preferredStyle: .alert
//        )
//        
//        let textField: TextField.Config = { textField in
//            textField.leftViewPadding = 0
//            textField.becomeFirstResponder()
//            textField.borderWidth = 1
//            textField.cornerRadius = 8
//            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
//            textField.backgroundColor = nil
//            textField.textColor = .black
//            textField.placeholder = "Enter Password"
//            textField.keyboardAppearance = .default
//            textField.keyboardType = .decimalPad
//            textField.returnKeyType = .done
//            textField.action { textField in
//                Log("textField = \(String(describing: textField.text))")
//                
//                _ = textField.text ?? ""
//                
//                self.passwordLbl.text = "\(String(describing: textField.text!))"
//                UserDefaults.standard.set(self.passwordLbl.text!, forKey: AppConstants.Defaults.Key.Password)
//            }
//        }
//        
//        alert.addOneTextField(configuration: textField)
//        
//        alert.addAction(title: "Done", style: .cancel)
//        self.present(alert, animated: true, completion: nil)
//        //        alert.show()
//    }
    
    /// <#Description#>
    @IBOutlet weak var currency: UILabel!
    
    /// <#Description#>
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
