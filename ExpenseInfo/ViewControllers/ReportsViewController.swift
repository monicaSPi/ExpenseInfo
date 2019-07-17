

import UIKit
import CoreData
import MessageUI

// MARK: - MFMailComposeViewControllerDelegate
extension ReportsViewController: MFMailComposeViewControllerDelegate {
    
}
/// <#Description#>
class ReportsViewController: UIViewController {
    
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
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func reportGenerate(_ sender: UIButton) {
        
        generateReportforExpense()
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
    @IBOutlet weak var generatereportBtn: UIButton! {
        didSet {
            generatereportBtn.isHidden = false
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
    @IBAction func reportsSegmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.expenseContainer.isHidden = false
            self.reimburseContainer.isHidden = true
            generatereportBtn.isHidden = false
        } else if sender.selectedSegmentIndex == 1 {
            self.expenseContainer.isHidden = true
            self.reimburseContainer.isHidden = false
            generatereportBtn.isHidden = false
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var stack1: UIStackView!
    
    /// <#Description#>
    @IBOutlet weak var stack2: UIStackView!
    
    /// <#Description#>
    var isMenuActive = false
    
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
    ///
    /// - Parameters:
    ///   - controller: <#controller description#>
    ///   - result: <#result description#>
    ///   - error: <#error description#>
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result.rawValue == 2 {
            //  updateSubmitted()
        }
        controller.dismiss(animated: true)
    }
    
    /// <#Description#>
    func showMenu() {
        
        
        self.shadowView.isHidden = false
        self.optionsView.isHidden = false
        
    }
    
    /// <#Description#>
    @IBOutlet weak var reimburseContainer: UIView!
    
    /// <#Description#>
    @IBOutlet weak var expenseContainer: UIView!
    
    /// <#Description#>
    @IBOutlet weak var scrollView: UIScrollView!
    /// Called after the controller's view is loaded into memory.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
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
            menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
            hideMenu()
        } else {
            menuButton.setImage(UIImage(named: "retakeButton"), for: .normal)
            
            self.showMenu()
        }
        self.stack1.isHidden = isMenuActive ? false : true
        self.stack2.isHidden = isMenuActive ? false : true
        isMenuActive = isMenuActive ? false : true
    }
    
    /// <#Description#>
    @IBOutlet weak var optionsView: UIView!
    
    /// <#Description#>
    @IBOutlet weak var shadowView: UIView!
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func manualEntry(_ sender: UIButton) {
        UserDefaults.standard.set("Manual", forKey: AppConstants.Defaults.Key.AddExpenseType)
        
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.MainViewController) as? MainViewController
        self.present(firstVC!, animated: true, completion: nil)
        
    }
    
   /// Instance for a Data structure containing information about Expense List
    var expenseListArray = [ExpenseListInfo]()
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func uploadBill(_ sender: UIButton) {
        
        UserDefaults.standard.set("Upload", forKey: AppConstants.Defaults.Key.AddExpenseType)
        
        
        
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier:  AppConstants.Segue.Identifier.UploadViewController) as? UploadViewController
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
    
    
    /// <#Description#>
    func generateReportforExpense() {
        expenseListArray = [ExpenseListInfo]()
        
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        do {
            let fetchedtype = try AppConstants.managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            
            if fetchedtype.count > 0 {
            
                
                fetchedtype.forEach { (exp) in
                    var addAcc = ExpenseListInfo()
                    addAcc.merchantName = exp.merchantName
                    addAcc.amount = exp.amount
                    if let expenseMode = exp.expenseMode {
                        addAcc.expenseMode = expenseMode
                    }
                    addAcc.date = exp.dateString
                    addAcc.categoryImg = exp.expenseCategoryImg
                    addAcc.time = exp.timeString
                    addAcc.reimbursable = exp.reimbursable
                    addAcc.id = exp.id
                    addAcc.currencySymbol = exp.currencySymbolString
                    addAcc.category = exp.expenseCategory
                    addAcc.claimed = exp.isClaimed
                    addAcc.tags = exp.tags as? [String]
                    print(exp.tags as? [String] as Any)
                    addAcc.notes = exp.notes
                    if let expensebillImg = exp.billImage {
                        addAcc.billImg =  expensebillImg
                    }
                    expenseListArray.append(addAcc)
                }
                
                if expenseListArray.count > 0 {
                    let fileName = "Expense.csv"
                    let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
                    var csvText = "Date,Time,Category,Merchant,Amount,Tags,Description,Expense mode,Image\n"
                    
                    let billImages: NSMutableArray = [] //
                    var zipBill = [EmailBill]()
                    expenseListArray.forEach { (task) in
                        var tagString : NSMutableString = ""
                        
                        if task.tags?.count > 0 {
                            if let valueString = task.tags {
                                for val in valueString {
                                    tagString.append("#\(val) ")
                                }
                            }
                            
                        } else {
                            tagString = "---"
                        }
                        var notes : String = "---"
                        if task.notes != "" {
                            notes = task.notes!
                        }
                        
                        var billImg : String = ""
                        if let taskBillImg = task.billImg {
                            print("bill Available")
                            var bills = EmailBill()
                            if let ids = task.id {
                                bills.name = "\(ids).png"
                                billImg = "\(ids).png"
                                
                            }
                            
                            bills.image = taskBillImg
                            zipBill.append(bills)
                            
                            billImages.add(taskBillImg)
                            
                            
                            
                        }
                        if let dateValue = task.date, let timeValue = task.time , let categoryValue = task.category, let merchantValue = task.merchantName, let currencyValue = task.currencySymbol, let amountValue = task.amount {
                            var expenseString = ""
                            if let expensemodeValue = task.expenseMode {
                                expenseString = expensemodeValue
                            } else {
                                expenseString = ""
                            }
                            let newLine = "\(dateValue),\(timeValue),\(categoryValue),\(merchantValue),\(currencyValue)\(amountValue),\(tagString),\(notes),\(expenseString),\(billImg) \n"
                            
                            print(newLine)
                            csvText.append(contentsOf: newLine)
                        } else {
                        }
                        
                    }
                    
                    
                    do {
                        try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                        
                        //
                        
                        if MFMailComposeViewController.canSendMail() {
                            let emailController = MFMailComposeViewController()
                            emailController.mailComposeDelegate = self
                            emailController.setToRecipients([])
                            emailController.setSubject("Expense data export")
                            emailController.setMessageBody("Hi,\n\nThe .csv data report is attached\n\n\n\n\nSent from the Expense App", isHTML: false)
                            emailController.addAttachmentData(NSData(contentsOf: path!)! as Data, mimeType: "csv", fileName: "Expense.csv")
                            
                            
                            
                            
                            zipBill.forEach { (value) in
                                if let imageValue = value.image, let nameValue = value.name {
                                    emailController.addAttachmentData(imageValue, mimeType: "image/png", fileName: nameValue)
                                    
                                }
                            }
                            
                            
                            present(emailController, animated: true, completion: nil)
                        } else {
                            showSendMailErrorAlert()
                        }
                        
                        
                    } catch {
                        print("Failed to create file")
                        print("\(error)")
                    }
                }
                
            } else {
            }
        } catch {
            
            
        }
        
        
    }
    
    /// <#Description#>
    func showSendMailErrorAlert() {
        
        let alert = UIAlertController(title: "Email Failed", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}
