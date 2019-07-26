

import UIKit
import WSTagsField
import CoreData
import MessageUI


// MARK: - MFMailComposeViewControllerDelegate
extension ExpenseDetailsViewController: MFMailComposeViewControllerDelegate {
    /// Tells the delegate that the user wants to dismiss the mail composition view.
    ///
    /// - Parameters:
    ///   - controller: The view controller object managing the mail composition view.
    ///   - result: The result of the user’s action.
    ///   - error: If an error occurred, this parameter contains an error object with information about the type of failure.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result.rawValue == 2 {
            updateSubmitted()
        }
        controller.dismiss(animated: true)
    }
    
}

/// Manages the detailed description of the Expense made
class ExpenseDetailsViewController: UIViewController {
    
    // MARK: IBOutlet Properties
    
    /// topBar that manages the content for a top rectangular area on the screen.
    @IBOutlet weak var topBar: UIView!
    
    /// Designable detailView
    @IBOutlet weak var detailView: RoundView! {
        didSet {
            detailView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            detailView.layer.shadowOffset = CGSize(width: 0, height: 3)
            detailView.layer.shadowOpacity = 1.0
            detailView.layer.shadowRadius = 10.0
            detailView.layer.masksToBounds = false
        }
    }
    
    /// This label shows the empty tag field
    @IBOutlet weak var mEmptyTag: UILabel!
    
    /// Designable roundImages
    @IBOutlet weak var roundImages: RoundImage! {
        didSet {
            roundImages.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            roundImages.layer.shadowOffset = CGSize(width: 0, height: 3)
            roundImages.layer.shadowOpacity = 1.0
            roundImages.layer.shadowRadius = 10.0
            roundImages.layer.masksToBounds = false
        }
    }
    
    /// This displays the amount of the expense with the currency symbol
    @IBOutlet weak var mAmount: UILabel! {
        didSet {
            mAmount.text = "\(expenseDetailsViewModel.expenseListArray.currencySymbol!)\(expenseDetailsViewModel.expenseListArray.amount!)"
        }
    }
    
    /// shortView that manages the content for a rectangular area on the screen.
    @IBOutlet weak var shortView: UIView!
    
    /// This displayes the merchant name for which the expense is made
    @IBOutlet weak var mmerchantName: UILabel! {
        didSet {
            mmerchantName.text = expenseDetailsViewModel.expenseListArray.merchantName
            
        }
    }
    
    /// This displays under which category the expense is made
    @IBOutlet weak var mCategory: UILabel! {
        didSet {
            mCategory.text = expenseDetailsViewModel.expenseListArray.category
            
        }
    }
    
    /// A scrollable, multiline text region. contains notes of the expense made
    @IBOutlet weak var mDescription: UITextView! {
        didSet {
            
            mDescription.text = expenseDetailsViewModel.expenseListArray.notes
            if mDescription.text == "" {
                mDescription.text = "---"
            }
        }
    }
    
    /// This shows the category image
    @IBOutlet weak var mCategoryImg: UIImageView! {
        didSet {
            mCategoryImg.image = UIImage(data: expenseDetailsViewModel.expenseListArray.categoryImg!)
            
        }
    }
    
    /// This custom button is to perform claim operation
    @IBOutlet weak var claimBtn: UIButton! {
        didSet {
            claimBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            claimBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            claimBtn.layer.shadowOpacity = 1.0
            claimBtn.layer.shadowRadius = 10.0
            claimBtn.layer.masksToBounds = false
        }
    }
    
    /// This image is used to send the email regarding the expense
    @IBOutlet weak var screenShot: UIImageView!
    
    /// The claimed button is used to denote that the expense is claimed already
    @IBOutlet weak var claimedBttn: UIButton!
    
    /// This displays the date and time of the expense made
    @IBOutlet weak var mdate: UILabel! {
        didSet {
            mdate.text = "\(String(describing: expenseDetailsViewModel.expenseListArray.date!)) - \(String(describing: expenseDetailsViewModel.expenseListArray.time!))"
        }
    }
    
    /// This displayes the merchant name for which the expense is made
    @IBOutlet weak var MerchantName: UILabel! {
        didSet {
            MerchantName.text = expenseDetailsViewModel.expenseListArray.merchantName
        }
    }
    
    /// This displays the amount of the expense with the currency symbol
    @IBOutlet weak var amount: UILabel! {
        didSet {
            amount.text = "\(expenseDetailsViewModel.expenseListArray.currencySymbol!)\(expenseDetailsViewModel.expenseListArray.amount!)"
            
        }
    }
    
    /// This displays under which category the expense is made
    @IBOutlet weak var category: UILabel! {
        didSet {
            category.text = expenseDetailsViewModel.expenseListArray.category
            
        }
    }
    
    /// This displays the date and time of the expense made
    @IBOutlet weak var dateandTime: UILabel! {
        didSet {
            dateandTime.text = "\(String(describing: expenseDetailsViewModel.expenseListArray.date!)) - \(String(describing: expenseDetailsViewModel.expenseListArray.time!))"
            
        }
    }
    
    /// This shows the category image
    @IBOutlet weak var catImage: UIImageView! {
        didSet {
            catImage.image = UIImage(data: expenseDetailsViewModel.expenseListArray.categoryImg!)
        }
    }
    
    /// A scrollable, multiline text region. for notes about the expense
    @IBOutlet weak var notes: UITextView! {
        didSet {
            
            notes.text = expenseDetailsViewModel.expenseListArray.notes
            if notes.text == "" {
                notes.text = "---"
            }
        }
    }
    
    /// tagsView that manages the content for a rectangular area on the screen.
    @IBOutlet weak var tagsView: UIView!
    
    /// emptyTag that manages the content for a rectangular area on the screen.
    @IBOutlet weak var emptyTag: UILabel!
    
    /// mTagsView that manages the content for a rectangular area on the screen.
    @IBOutlet weak var mTagsView: UIView!
    
    
    /// Instance of ExpenseDetailsViewModel
    let expenseDetailsViewModel = ExpenseDetailsViewModel()
    
    // MARK: Default View Controller Methods
    /// Called after the controller's view is loaded into memory.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        expenseDetailsViewModel.tagsField.readOnly = true
        
        if expenseDetailsViewModel.expenseListArray.claimed == "NC" {
            claimBtn.isHidden = false
            claimedBttn.isHidden = true
        } else if expenseDetailsViewModel.expenseListArray.claimed == "SB" {
            claimBtn.isHidden = true
            claimedBttn.isHidden = false
        } else {
            claimBtn.isHidden = true
            claimedBttn.isHidden = true
        }
        
        expenseDetailsViewModel.tagsField.layoutMargins = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
        expenseDetailsViewModel.tagsField.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
        expenseDetailsViewModel.tagsField.spaceBetweenTags = 10
        expenseDetailsViewModel.tagsField.backgroundColor = .clear
        expenseDetailsViewModel.tagsField.font = UIFont(name: "MyriadPro-Regular", size: 14.0)
        expenseDetailsViewModel.tagsField.textColor = UIColor(hexString: "2F3C4B")
        expenseDetailsViewModel.tagsField.fieldTextColor = UIColor(hexString: "2F3C4B")
        expenseDetailsViewModel.tagsField.selectedColor = UIColor(hexString: "FCECD4")
        expenseDetailsViewModel.tagsField.selectedTextColor = UIColor(hexString: "2F3C4B")
        expenseDetailsViewModel.tagsField.tintColor = UIColor(hexString: "FCECD4")
        expenseDetailsViewModel.tagsField.acceptTagOption = .space
        expenseDetailsViewModel.tagsField.frame = (self.tagsView?.bounds)!
        expenseDetailsViewModel.tagsField.frame(forAlignmentRect: CGRect(x: 10, y: 10, width: Int(expenseDetailsViewModel.tagsField.width), height: Int(expenseDetailsViewModel.tagsField.height)))
        tagsView?.addSubview(expenseDetailsViewModel.tagsField)
        mTagsView?.addSubview(expenseDetailsViewModel.tagsField)
        if expenseDetailsViewModel.expenseListArray.tags?.count > 0 {
            let valueString = expenseDetailsViewModel.expenseListArray.tags
            let tagString : NSMutableString = ""
            //
            
            valueString?.forEach({ (val) in
                tagString.append("#\(val) ")
                
            })
            emptyTag.text = tagString as String
            mEmptyTag.text = tagString as String
        } else {
            self.emptyTag.isHidden = false
            self.mEmptyTag.isHidden = false
        }
    }
    // MARK: IBAction Methods
    
    /// This method is used to dismiss this viewcontroller from the stack of viewcontrollers
    ///
    /// - Parameter sender: sender id
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// This method is used to delete the expense from the core data database
    ///
    /// - Parameter sender: sender id
    @IBAction func deleteExpense(_ sender: UIButton) {
        print(expenseDetailsViewModel.expenseListArray.id as Any)
        deleteProfile(withID: expenseDetailsViewModel.expenseListArray.id!)
    }
    
    /// This method is used to edit the expense , so setting the `AddExpenseType` defaults to Edit and navigate to the MainViewController and perform the edit operation
    ///
    /// - Parameter sender: sender id
    @IBAction func editExpense(_ sender: UIButton) {
        let imageVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.MainViewController) as! MainViewController
        UserDefaults.standard.set("Edit", forKey: AppConstants.Defaults.Key.AddExpenseType)
        UserDefaults.standard.set(expenseDetailsViewModel.expenseListArray.id, forKey: AppConstants.Defaults.Key.expenseListArrayId)
        self.present(imageVC, animated: true, completion: nil)
    }
    
    /// This method is called when the user got reimbursement and clicked done claimed option
    ///
    /// - Parameter sender: sender id
    @IBAction func doneClaim(_ sender: UIButton) {
        updateClaimed()
    }
    
    /// The user wants to claim the expense by notifying it to the receipient via email with the expense details and the bill image
    ///
    /// - Parameter sender: sender id
    @IBAction func claimedAction(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            shortView.isHidden = false
            let renderer = UIGraphicsImageRenderer(size: shortView.bounds.size)
            let image = renderer.image { ctx in
                shortView.drawHierarchy(in: shortView.bounds, afterScreenUpdates: true)
            }
            screenShot.image = image
            screenShot.contentMode = .scaleAspectFit
            detailView.isHidden = false
            shortView.isHidden = true
            screenShot.isHidden = true
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self;
            mail.setSubject("Claim Expense")
            mail.setMessageBody("", isHTML: false)
            let imageData: Data? = screenShot.image!.pngData()
            mail.addAttachmentData(imageData!, mimeType: "image/png", fileName: "imageName.png")
            if let arrayBillImg = expenseDetailsViewModel.expenseListArray.billImg  {
                mail.addAttachmentData(arrayBillImg, mimeType: "image/png", fileName: "attachment.png")
            }
            self.present(mail, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    // MARK: - Custom Action
    
    /// This method is used to save the data to core data context
    func saveItems() {
        do {
            try AppConstants.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    /// This method is called when user want to delete the particular expense
    ///
    /// - Parameter withID: unique expenseID
    func deleteProfile(withID: String) {
        let alert = UIAlertController(title: "Alert", message: "Would you like to Delete?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            switch action.style{
            case .default:
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
                fetchRequest.predicate =  NSPredicate(format: "id == %@  ", withID)
                do {
                    let test = try AppConstants.managedObjectContext.fetch(fetchRequest)
                    let objectToDelete = test[0] as! NSManagedObject
                    AppConstants.managedObjectContext.delete(objectToDelete)
                    do {
                        try AppConstants.managedObjectContext.save()
                        self.dismiss(animated: true, completion: nil)
                    }
                    catch {
                        print(error)
                    }
                }
                catch {
                    print(error)
                }
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            @unknown default:
                break
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    /// This method is called when the user Submitted the expense , this will take you to the reimbursement view controller
    func updateSubmitted() {
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch.predicate = NSPredicate(format: "id == %@", expenseDetailsViewModel.expenseListArray.id!)
        do {
            let fetchedtype = try AppConstants.managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            if fetchedtype.count == 1 {
                
                fetchedtype.forEach { (expenseContent) in
                    expenseContent.id = expenseDetailsViewModel.expenseListArray.id!
                    expenseContent.reimbursable = true
                    expenseContent.isClaimed = "SB"
                    saveItems()
                    let imageVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ReimbursementViewController) as! ReimbursementViewController
                    self.present(imageVC, animated: true, completion: nil)
                }
            }
        } catch {
        }
    }
    
    /// This method is called when the user claimed the expense , this will take you to the reimbursement view controller
    func updateClaimed() {
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch.predicate = NSPredicate(format: "id == %@", expenseDetailsViewModel.expenseListArray.id!)
        do {
            let fetchedtype = try AppConstants.managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            if fetchedtype.count == 1 {
                
                fetchedtype.forEach { (expenseContent) in
                    expenseContent.id = expenseDetailsViewModel.expenseListArray.id!
                    expenseContent.reimbursable = false
                    expenseContent.isClaimed = "CL"
                    saveItems()
                    let imageVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ReimbursementViewController) as! ReimbursementViewController
                    self.present(imageVC, animated: true, completion: nil)
                    
                }
            }
        } catch {
        }
    }
    
    /// This method is called when the email is not sent with error message
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Email Failed", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    
    
    
    
    
    
    
}
