

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
    
    /// <#Description#>
    @IBOutlet weak var detailView: RoundView! {
        didSet {
            detailView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            detailView.layer.shadowOffset = CGSize(width: 0, height: 3)
            detailView.layer.shadowOpacity = 1.0
            detailView.layer.shadowRadius = 10.0
            detailView.layer.masksToBounds = false
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var mEmptyTag: UILabel!
    
    /// <#Description#>
    @IBOutlet weak var roundImages: RoundImage! {
        didSet {
            roundImages.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            roundImages.layer.shadowOffset = CGSize(width: 0, height: 3)
            roundImages.layer.shadowOpacity = 1.0
            roundImages.layer.shadowRadius = 10.0
            roundImages.layer.masksToBounds = false
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var mAmount: UILabel! {
        didSet {
              mAmount.text = "\(expenseDetailsViewModel.expenseListArray.currencySymbol!)\(expenseDetailsViewModel.expenseListArray.amount!)"
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var shortView: UIView!
    
    /// <#Description#>
    @IBOutlet weak var mmerchantName: UILabel! {
        didSet {
            mmerchantName.text = expenseDetailsViewModel.expenseListArray.merchantName

        }
    }
    
    /// <#Description#>
    @IBOutlet weak var mCategory: UILabel! {
        didSet {
            mCategory.text = expenseDetailsViewModel.expenseListArray.category

        }
    }
    
    /// <#Description#>
    @IBOutlet weak var mDescription: UITextView! {
        didSet {
            
            mDescription.text = expenseDetailsViewModel.expenseListArray.notes
            if mDescription.text == "" {
                mDescription.text = "---"
            }
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var mCategoryImg: UIImageView! {
        didSet {
            mCategoryImg.image = UIImage(data: expenseDetailsViewModel.expenseListArray.categoryImg!)

        }
    }
    
    /// <#Description#>
    @IBOutlet weak var claimBtn: UIButton! {
        didSet {
            claimBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            claimBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            claimBtn.layer.shadowOpacity = 1.0
            claimBtn.layer.shadowRadius = 10.0
            claimBtn.layer.masksToBounds = false
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var screenShot: UIImageView!
    
    /// <#Description#>
    @IBOutlet weak var claimedBttn: UIButton!
    
    /// <#Description#>
    @IBOutlet weak var mdate: UILabel! {
        didSet {
            mdate.text = "\(String(describing: expenseDetailsViewModel.expenseListArray.date!)) - \(String(describing: expenseDetailsViewModel.expenseListArray.time!))"

        }
    }
    
    /// <#Description#>
    @IBOutlet weak var MerchantName: UILabel! {
        didSet {
                 MerchantName.text = expenseDetailsViewModel.expenseListArray.merchantName
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var amount: UILabel! {
        didSet {
            amount.text = "\(expenseDetailsViewModel.expenseListArray.currencySymbol!)\(expenseDetailsViewModel.expenseListArray.amount!)"

        }
    }
    
    /// <#Description#>
    @IBOutlet weak var category: UILabel! {
        didSet {
            category.text = expenseDetailsViewModel.expenseListArray.category

        }
    }
    
    /// <#Description#>
    @IBOutlet weak var dateandTime: UILabel! {
        didSet {
            dateandTime.text = "\(String(describing: expenseDetailsViewModel.expenseListArray.date!)) - \(String(describing: expenseDetailsViewModel.expenseListArray.time!))"

        }
    }
    
    /// <#Description#>
    @IBOutlet weak var catImage: UIImageView! {
        didSet {
              catImage.image = UIImage(data: expenseDetailsViewModel.expenseListArray.categoryImg!)
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var notes: UITextView! {
        didSet {
            
            notes.text = expenseDetailsViewModel.expenseListArray.notes
            if notes.text == "" {
                notes.text = "---"
            }
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var tagsView: UIView!
    
    /// <#Description#>
    @IBOutlet weak var emptyTag: UILabel!
    
    /// <#Description#>
    @IBOutlet weak var mTagsView: UIView!
    
    
  /// <#Description#>
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
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func deleteExpense(_ sender: UIButton) {
        print(expenseDetailsViewModel.expenseListArray.id as Any)
        deleteProfile(withID: expenseDetailsViewModel.expenseListArray.id!)
    }
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func editExpense(_ sender: UIButton) {
        let imageVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.MainViewController) as! MainViewController
        UserDefaults.standard.set("Edit", forKey: AppConstants.Defaults.Key.AddExpenseType)
        UserDefaults.standard.set(expenseDetailsViewModel.expenseListArray.id, forKey: AppConstants.Defaults.Key.expenseListArrayId)
        self.present(imageVC, animated: true, completion: nil)
    }
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func doneClaim(_ sender: UIButton) {
        updateClaimed()
    }
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
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
    
    /// <#Description#>
    func saveItems() {
        do {
            try AppConstants.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter withID: <#withID description#>
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
    
    /// <#Description#>
    func sendEmail() {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([])
        mailVC.setSubject("Subject for email")
        mailVC.setMessageBody("Email message string", isHTML: false)
        present(mailVC, animated: true, completion: nil)
    }
    
    
    /// <#Description#>
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
    
    /// <#Description#>
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
    
    /// <#Description#>
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Email Failed", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
  
    
    
    
    
    
    
    
}
