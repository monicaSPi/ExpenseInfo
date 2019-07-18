

import UIKit
import SafariServices
import Photos
import CoreTelephony
import CoreData
import MobileCoreServices
import WeScan

/// This ViewController is like a dashboard for the current application
class HomeViewController: UIViewController {
    
    // MARK: IBOutlet Properties
    
    /// If this button is pressed will take us to the Reimbursement view controller to view the reimbursement details
    @IBOutlet weak var reimbursementBtn: RoundButton! {
        didSet {
            reimbursementBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            reimbursementBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            reimbursementBtn.layer.shadowOpacity = 1.0
            reimbursementBtn.layer.shadowRadius = 10.0
            reimbursementBtn.layer.masksToBounds = false
        }
    }
    
     /// If this button is pressed will take us to the ExpenseList view controller to view the Expense list
    @IBOutlet weak var expenseBtn: RoundButton! {
        didSet {
            expenseBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            expenseBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            expenseBtn.layer.shadowOpacity = 1.0
            expenseBtn.layer.shadowRadius = 10.0
            expenseBtn.layer.masksToBounds = false
        }
    }
    
     /// If this button is pressed will take us to the Report view controller to view the report details
    @IBOutlet weak var reportBtn: RoundButton! {
        didSet {
            reportBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            reportBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            reportBtn.layer.shadowOpacity = 1.0
            reportBtn.layer.shadowRadius = 10.0
            reportBtn.layer.masksToBounds = false
        }
    }
    
     /// If this button is pressed will take us to the camera  to capture an image
    @IBOutlet weak var snapBillBtn: RoundButton! {
        didSet {
            snapBillBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            snapBillBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            snapBillBtn.layer.shadowOpacity = 1.0
            snapBillBtn.layer.shadowRadius = 10.0
            snapBillBtn.layer.masksToBounds = false
        }
    }
    
     /// If this button is pressed will take us to the upload view controller to open the gallery and select an image
    @IBOutlet weak var uploadBillBtn: RoundButton! {
        didSet {
            uploadBillBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            uploadBillBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            uploadBillBtn.layer.shadowOpacity = 1.0
            uploadBillBtn.layer.shadowRadius = 10.0
            uploadBillBtn.layer.masksToBounds = false
        }
    }
    
    /// If this button is pressed will take us to the add new expense controller to manually create an expense
    @IBOutlet weak var enterBillBtn: RoundButton! {
        didSet {
            enterBillBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            enterBillBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            enterBillBtn.layer.shadowOpacity = 1.0
            enterBillBtn.layer.shadowRadius = 10.0
            enterBillBtn.layer.masksToBounds = false
        }
    }
    
    /// Expense year and Month label
    @IBOutlet weak var expenseYearandMonth: UILabel!
    
    /// Reimbursement year and month label
    @IBOutlet weak var reimbursementYearandMonth: UILabel!
    
    /// UnClaimed label
    @IBOutlet weak var unClaimedLbl: UILabel!
    
    /// Claimed label
    @IBOutlet weak var claimedLbl: UILabel!
    
    /// Expense label
    @IBOutlet weak var expenseLBL: UILabel!
    
    // MARK: - ViewModel Variable
    
    /// HomeViewModel instance
    let homeViewModel = HomeViewModel()
    
    /// Instance of user default
    let defaults = UserDefaults.standard
    
    
    // MARK: Default View Controller Methods
    
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.CurrencyCode) != nil {
            if let currencySymbol = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.CurrencySymbol) {
                homeViewModel.globalCurrencySymbol = "\(currencySymbol)"
            } else {
                homeViewModel.globalCurrencySymbol = ""
            }
        }
        
        if let month :String  = defaults.value(forKey: AppConstants.Defaults.Key.Month) as? String {
            self.expenseYearandMonth.text = "\(month.uppercased()) - \(defaults.value(forKey: AppConstants.Defaults.Key.Year)!)"
            self.reimbursementYearandMonth.text = "\(month.uppercased()) - \(defaults.value(forKey: AppConstants.Defaults.Key.Year)!)"
        }
        homeViewModel.updateExpenseBlocks()
        homeViewModel.getClaimedandUnclaimedList()
        
        expenseLBL.text = "\(homeViewModel.globalCurrencySymbol)\(String(format:"%.2f", homeViewModel.expenseValueBlock))"
        claimedLbl.text = "\(homeViewModel.globalCurrencySymbol)\(String(format:"%.2f", homeViewModel.claimedValueBlock))"
        unClaimedLbl.text = "\(homeViewModel.globalCurrencySymbol)\(String(format:"%.2f", homeViewModel.unclaimedValueBlock))"
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    ///
    /// - Parameter animated: If true, the view is being added to the window using an animation.

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: IBAction Methods
    
    /// This IBAction navigate to `ReportsViewController`
    ///
    /// - Parameter sender: reportBtn id
    @IBAction func goToReports(_ sender: UIButton) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ReportsViewController) as? ReportsViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    
    /// This IBAction navigate to `ReimbursementViewController`
    ///
    /// - Parameter sender: reimbursementBtn id
    @IBAction func goToReimbursement(_ sender: UIButton) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ReimbursementViewController) as? ReimbursementViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    
    /// This IBAction navigate to `ExpenseViewController`
    ///
    /// - Parameter sender: expenseBtn id
    @IBAction func goToExpense(_ sender: UIButton) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ExpenseViewController) as? ExpenseViewController
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
    
    /// This IBAction navigate to `MainViewController`
    ///
    /// - Parameter sender: enterBillBtn id
    @IBAction func enterBillAction(_ sender: UIButton) {
        UserDefaults.standard.set("Manual", forKey: AppConstants.Defaults.Key.AddExpenseType)
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.MainViewController) as? MainViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    
    
}
