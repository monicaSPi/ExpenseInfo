

import UIKit
import CoreData
import MessageUI

// MARK: - UICollectionViewDataSource
extension ReimbursementViewController: UICollectionViewDataSource {
    /// Asks your data source object for the cell that corresponds to the specified item in the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - indexPath: The index path that specifies the location of the item.

    /// - Returns: A configured cell object. You must not return nil from this method.
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        let cell = UICollectionViewCell()
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reimbursemntViewModel.cellId1, for: indexPath) as! ExpenseCell
            
            let share = reimbursemntViewModel.claimedListArray[indexPath.row]
            cell.clearCell()
            var modeImg = UIImage()
            if share.expenseMode != nil {
                if share.expenseMode == "Manual" {
                    modeImg = UIImage(named: "manual-bill")!
                }else if share.expenseMode == "Snap" {
                    modeImg = UIImage(named: "snap-bills")!
                    
                } else if share.expenseMode == "Upload" {
                    modeImg = UIImage(named: "upload-bill")!
                    
                }
            }
            cell.modeImg.image = modeImg
            cell.merchantDetails.text = share.merchantName
            cell.categoryIcon.image = UIImage(data:share.categoryImg!)
            cell.amount.text = "\(share.currencySymbol!)\(share.amount!)"
            
            cell.tagsView = nil
            //            print("indexPath \(indexPath.row) value : \(share.tags)")
            if let sharetags = share.tags {
                cell.configureTags(value: sharetags)
                cell.tagsView?.isHidden = false
            } else {
                cell.tagsView?.isHidden = true
            }
            
            
            cell.date.text =
            "\(share.date!) - \(share.time!)"
            
            return cell
        } else if collectionView == self.unClaimedCollectionView   {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reimbursemntViewModel.cellId2, for: indexPath) as! ExpenseCell
            
            let share = reimbursemntViewModel.unclaimedListArray[indexPath.row]
            cell.clearCell()
            var modeImg = UIImage()
            if share.expenseMode != nil {
                if share.expenseMode == "Manual" {
                    modeImg = UIImage(named: "manual-bill")!
                }else if share.expenseMode == "Snap" {
                    modeImg = UIImage(named: "snap-bills")!
                    
                } else if share.expenseMode == "Upload" {
                    modeImg = UIImage(named: "upload-bill")!
                    
                }
            }
            cell.modeImg.image = modeImg
            cell.merchantDetails.text = share.merchantName
            cell.categoryIcon.image = UIImage(data:share.categoryImg!)
            cell.amount.text = "\(share.currencySymbol!)\(share.amount!)"
            
            cell.tagsView = nil
            //            print("indexPath \(indexPath.row) value : \(share.tags)")
            if let sharetags = share.tags {
                cell.configureTags(value: sharetags)
                cell.tagsView?.isHidden = false
            } else {
                cell.tagsView?.isHidden = true
            }
            
            
            cell.date.text =
            "\(share.date!) - \(share.time!)"
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reimbursemntViewModel.cellId3, for: indexPath) as! ExpenseCell
            
            let share = reimbursemntViewModel.submittedListArray[indexPath.row]
            cell.clearCell()
            var modeImg = UIImage()
            if share.expenseMode != nil {
                if share.expenseMode == "Manual" {
                    modeImg = UIImage(named: "manual-bill")!
                }else if share.expenseMode == "Snap" {
                    modeImg = UIImage(named: "snap-bills")!
                    
                } else if share.expenseMode == "Upload" {
                    modeImg = UIImage(named: "upload-bill")!
                    
                }
            }
            cell.modeImg.image = modeImg
            cell.merchantDetails.text = share.merchantName
            cell.categoryIcon.image = UIImage(data:share.categoryImg!)
            cell.amount.text = "\(share.currencySymbol!)\(share.amount!)"
            
            cell.tagsView = nil
            //            print("indexPath \(indexPath.row) value : \(share.tags)")
            if let sharetags = share.tags {
                cell.configureTags(value: sharetags)
                cell.tagsView?.isHidden = false
            } else {
                cell.tagsView?.isHidden = true
            }
            
            
            cell.date.text =
            "\(share.date!) - \(share.time!)"
            
            return cell
        }
        //  return cell
    }
    
    /// Asks your data source object for the number of items in the specified section.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - section: An index number identifying a section in collectionView. This index value is 0-based.
    /// - Returns: The number of rows in section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            if (reimbursemntViewModel.claimedListArray.count == 0) {
                self.collectionView.setEmptyMessage("")
                self.emptyImageBox.isHidden = false
            } else {
                self.emptyImageBox.isHidden = true
                self.collectionView.restore()
            }
            
            
            return reimbursemntViewModel.claimedListArray.count
        } else if collectionView == self.unClaimedCollectionView {
            if (reimbursemntViewModel.unclaimedListArray.count == 0) {
                self.unClaimedCollectionView.setEmptyMessage("")
                self.emptyImageBox.isHidden = false
            } else {
                self.emptyImageBox.isHidden = true
                self.unClaimedCollectionView.restore()
            }
            
            
            return reimbursemntViewModel.unclaimedListArray.count
        } else if collectionView == self.submittedCollectionView {
            if (reimbursemntViewModel.submittedListArray.count == 0) {
                self.emptyImageBox.isHidden = false
                self.submittedCollectionView.setEmptyMessage("")
            } else {
                self.emptyImageBox.isHidden = true
                self.submittedCollectionView.restore()
            }
            
            
            return reimbursemntViewModel.submittedListArray.count
        }
        return 0
    }
}

// MARK: - UICollectionViewDelegate
extension ReimbursementViewController: UICollectionViewDelegate {
    /// Tells the delegate that the item at the specified index path was selected.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view object that is notifying you of the selection change.
    ///   - indexPath: The index path of the cell that was selected.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ExpenseDetailsViewController) as? ExpenseDetailsViewController
        if collectionView == unClaimedCollectionView {
            
            let share = reimbursemntViewModel.unclaimedListArray[indexPath.row]
            vc2?.expenseDetailsViewModel.expenseListArray = share
            self.present(vc2!, animated: true)
        } else if collectionView == submittedCollectionView {
            
            let share = reimbursemntViewModel.submittedListArray[indexPath.row]
            vc2?.expenseDetailsViewModel.expenseListArray = share
            self.present(vc2!, animated: true)
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension ReimbursementViewController: MFMailComposeViewControllerDelegate {
    
}
/// This ViewController is used to show the claimed expense, unclaimed expense, submitted expense in a single roof using segments
class ReimbursementViewController: UIViewController {
   
    // MARK: - ViewModel Variable
    
    /// Instance of ReimbursementViewModel
    let reimbursemntViewModel = ReimbursementViewModel()
    // MARK: IBOutlet Properties
    
    
    /// stack1 an interface for laying out a collection of views in either a column or a row.
    @IBOutlet weak var stack1: UIStackView!
    
    /// stack2 an interface for laying out a collection of views in either a column or a row.
    @IBOutlet weak var stack2: UIStackView!
    
    /// optionsView that manages the content for a rectangular area on the screen.
    @IBOutlet weak var optionsView: UIView!
    
    /// shadowView that manages the content for a rectangular area on the screen.
    @IBOutlet weak var shadowView: UIView!
    
    /// submittedCollectionView that manages an ordered collection of data items and presents them using customizable layouts.
    @IBOutlet weak var submittedCollectionView: UICollectionView!

    /// unClaimedCollectionView that manages an ordered collection of data items and presents them using customizable layouts.

    @IBOutlet weak var unClaimedCollectionView: UICollectionView!
    
    /// segmentControl is a horizontal control made of multiple segments, each segment functioning as a discrete button.
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    /// collectionView that manages an ordered collection of data items and presents them using customizable layouts.
    @IBOutlet weak var collectionView: UICollectionView!

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
    
    /// emptyImageBox that displays a single image or a sequence of animated images in your interface. when there is nothing to show
    @IBOutlet weak var emptyImageBox: UIImageView!
    
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


        // MARK: IBAction Methodss
    
    /// When this snap bill is pressed , it updates the AddExpenseType Defaults and navigate to ScannerViewController
    ///
    /// - Parameter sender: sender id
    @IBAction func snapBill(_ sender: UIButton) {
        UserDefaults.standard.set("Snap", forKey: AppConstants.Defaults.Key.AddExpenseType)
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ScannerViewController) as? ScannerViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    
    /// When menu is pressed from the bottom bar it opens the optionsView and should change the value of isMenuActive Value
    ///
    /// - Parameter sender: menuButton id
    @IBAction func menuButtonAction(_ sender: UIButton) {
        
        if reimbursemntViewModel.isMenuActive {
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
        self.stack1.isHidden = reimbursemntViewModel.isMenuActive ? false : true
        self.stack2.isHidden = reimbursemntViewModel.isMenuActive ? false : true
        reimbursemntViewModel.isMenuActive = reimbursemntViewModel.isMenuActive ? false : true
        
    }
    
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

    /// A horizontal control made of multiple segments, each segment functioning as a discrete button.
    ///
    /// - Parameter sender: UISegmentedControl id
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.collectionView.isHidden = false
            collectionView.reloadData()
            self.unClaimedCollectionView.isHidden = true
            self.submittedCollectionView.isHidden = true
            
        } else if sender.selectedSegmentIndex == 1 {
            self.collectionView.isHidden = true
            self.unClaimedCollectionView.isHidden = true
            self.submittedCollectionView.isHidden = false
            submittedCollectionView.reloadData()
        } else if sender.selectedSegmentIndex == 2 {
            self.collectionView.isHidden = true
            self.unClaimedCollectionView.isHidden = false
            self.submittedCollectionView.isHidden = true
            
            unClaimedCollectionView.reloadData()
        }
    }
    
        // MARK: - Custom Calls
    
   /// Hide Options Menu
    func hideMenu() {
        self.shadowView.isHidden = true
        self.optionsView.isHidden = true
    }
    
    /// Show Options Menu
    func showMenu() {
        
        
        self.shadowView.isHidden = false
        self.optionsView.isHidden = false
        
    }
    
        // MARK: - UICollectionView Delegate
    

    // MARK: Default View Controller Methods
    /// Called after the controller's view is loaded into memory.

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: reimbursemntViewModel.cellId1, bundle: nil)
        collectionView.register( nib, forCellWithReuseIdentifier: reimbursemntViewModel.cellId1)
        collectionView.contentInset.bottom = reimbursemntViewModel.itemHeight
        let nib1 = UINib(nibName: reimbursemntViewModel.cellId2, bundle: nil)
        let nib2 = UINib(nibName: reimbursemntViewModel.cellId3, bundle: nil)
        submittedCollectionView.register( nib2, forCellWithReuseIdentifier: reimbursemntViewModel.cellId3)
        unClaimedCollectionView.register( nib1, forCellWithReuseIdentifier: reimbursemntViewModel.cellId2)
        unClaimedCollectionView.contentInset.bottom = reimbursemntViewModel.itemHeight
        configureCollectionViewLayout()
        configureCollectionViewLayout1()
        configureCollectionViewLayout2()
        collectionView.reloadData()
        submittedCollectionView.reloadData()
        unClaimedCollectionView.reloadData()
        self.collectionView.isHidden = false
        self.submittedCollectionView.isHidden = true
        self.unClaimedCollectionView.isHidden = true
    }
    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    ///
    /// - Parameter animated: If true, the disappearance of the view is being animated.

    override func viewWillDisappear(_ animated: Bool) {
        self.stack1.isHidden = false
        self.stack2.isHidden = false
        menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
        hideMenu()
        
        reimbursemntViewModel.isMenuActive = false
    }
    

    /// This method configure the collectionView Layout
    private func configureCollectionViewLayout() {
        let lineSpacing: CGFloat = reimbursemntViewModel.lineSpacingValue()

        guard let layout = collectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: reimbursemntViewModel.topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * reimbursemntViewModel.xInset
        layout.itemSize = CGSize(width: itemWidth, height: reimbursemntViewModel.itemHeight)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    /// This method configure the unClaimedCollectionView Layout
    private func configureCollectionViewLayout1() {
        let lineSpacing: CGFloat = reimbursemntViewModel.lineSpacingValue()

        guard let layout = unClaimedCollectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: reimbursemntViewModel.topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * reimbursemntViewModel.xInset
        layout.itemSize = CGSize(width: itemWidth, height: reimbursemntViewModel.itemHeight)
        unClaimedCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    /// This method configure the submittedCollectionView Layout
    private func configureCollectionViewLayout2() {
        let lineSpacing: CGFloat = reimbursemntViewModel.lineSpacingValue()

        guard let layout = submittedCollectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: reimbursemntViewModel.topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * reimbursemntViewModel.xInset
        layout.itemSize = CGSize(width: itemWidth, height: reimbursemntViewModel.itemHeight)
        submittedCollectionView.collectionViewLayout.invalidateLayout()
    }
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    ///
    /// - Parameter animated: If true, the view is being added to the window using an animation.

    override func viewWillAppear(_ animated: Bool) {
        getReimbursementDetailsList()
        collectionView.reloadData()
        submittedCollectionView.reloadData()
        unClaimedCollectionView.reloadData()
    }
    
    /// This method is used to get the Reimbursement details from the coredata model and categories into unclaimedList , claimedList, submittedList and the tableViews of the respective tabs will get populated
    func getReimbursementDetailsList() {
        reimbursemntViewModel.unclaimedListArray = [ExpenseListInfo]()
        reimbursemntViewModel.claimedListArray = [ExpenseListInfo]()
        reimbursemntViewModel.submittedListArray = [ExpenseListInfo]()
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch.predicate = NSPredicate(format: "isClaimed == %@ ","CL")
        do {
            let fetchedtype = try AppConstants.managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            if fetchedtype.count > 0 {

                
                fetchedtype.forEach { (exp) in
                    var addAcc = ExpenseListInfo()
                    addAcc.merchantName = exp.merchantName
                    addAcc.amount = exp.amount
                    //                    let myString = exp.amount
                    //                    let myFloat = (myString! as NSString).doubleValue
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
                    addAcc.tags = exp.tags as? [String]
                    //                    print(exp.tags as? [String])
                    addAcc.claimed = exp.isClaimed
                    addAcc.notes = exp.notes
                    if let billImgs = exp.billImage {
                        addAcc.billImg =  billImgs
                    }
                    reimbursemntViewModel.claimedListArray.append(addAcc)
                }
                collectionView.reloadData()
                unClaimedCollectionView.reloadData()
            } else {
                if (reimbursemntViewModel.claimedListArray.count == 0) {
                    collectionView.reloadData()
                    unClaimedCollectionView.reloadData()
                    self.collectionView.setEmptyMessage("")
                     self.emptyImageBox.isHidden = false
                } else {
                     self.emptyImageBox.isHidden = true
                    self.collectionView.restore()
                }
            }
        } catch {
            
            
        }
        let typefetch2 = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch2.predicate = NSPredicate(format: "isClaimed == %@ ","SB")
        
        do {
            let fetchedtype1 = try AppConstants.managedObjectContext.fetch(typefetch2) as! [ExpenseContent]
            
            if fetchedtype1.count > 0 {

                fetchedtype1.forEach { (exp) in
                    var addAcc = ExpenseListInfo()
                    addAcc.merchantName = exp.merchantName
                    addAcc.amount = exp.amount
                    //                    let myString = exp.amount
                    //                    let myFloat = (myString as! NSString).doubleValue
                    if let expenseMode = exp.expenseMode {
                        addAcc.expenseMode = expenseMode
                    }
                    addAcc.date = exp.dateString
                    addAcc.claimed = exp.isClaimed
                    addAcc.categoryImg = exp.expenseCategoryImg
                    addAcc.time = exp.timeString
                    addAcc.reimbursable = exp.reimbursable
                    addAcc.id = exp.id
                    addAcc.currencySymbol = exp.currencySymbolString
                    addAcc.category = exp.expenseCategory
                    addAcc.tags = exp.tags as? [String]
                    //                    print(exp.tags as? [String])
                    addAcc.notes = exp.notes
                    
                    if let billImgs = exp.billImage {
                        addAcc.billImg =  billImgs
                    }
                    reimbursemntViewModel.submittedListArray.append(addAcc)
                }
                collectionView.reloadData()
                unClaimedCollectionView.reloadData()
                submittedCollectionView.reloadData()
            } else {
                if (reimbursemntViewModel.submittedListArray.count == 0) {
                    collectionView.reloadData()
                    unClaimedCollectionView.reloadData()
                    submittedCollectionView.reloadData()
                    self.submittedCollectionView.setEmptyMessage("")
                     self.emptyImageBox.isHidden = false
                } else {
                     self.emptyImageBox.isHidden = true
                    self.submittedCollectionView.restore()
                }
            }
        } catch {
            
            
        }
        
        
        
        let typefetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch1.predicate = NSPredicate(format: "isClaimed == %@ ","NC")
        
        do {
            let fetchedtype1 = try AppConstants.managedObjectContext.fetch(typefetch1) as! [ExpenseContent]
            
            if fetchedtype1.count > 0 {

                
                fetchedtype1.forEach { (exp) in
                    var addAcc = ExpenseListInfo()
                    addAcc.merchantName = exp.merchantName
                    addAcc.amount = exp.amount
                    //                    let myString = exp.amount
                    //                    let myFloat = (myString as! NSString).doubleValue
                    if let expenseMode = exp.expenseMode {
                        addAcc.expenseMode = expenseMode
                    }
                    
                    addAcc.date = exp.dateString
                    addAcc.categoryImg = exp.expenseCategoryImg
                    addAcc.time = exp.timeString
                    addAcc.reimbursable = exp.reimbursable
                    addAcc.id = exp.id
                    addAcc.currencySymbol = exp.currencySymbolString
                    addAcc.claimed = exp.isClaimed
                    addAcc.category = exp.expenseCategory
                    addAcc.tags = exp.tags as? [String]
                    //                    print(exp.tags as? [String])
                    addAcc.notes = exp.notes
                    
                    if let billImgs = exp.billImage {
                        addAcc.billImg =  billImgs
                    }
                    reimbursemntViewModel.unclaimedListArray.append(addAcc)
                }
                
//
                collectionView.reloadData()
                unClaimedCollectionView.reloadData()
            } else {
                if (reimbursemntViewModel.unclaimedListArray.count == 0) {
                    collectionView.reloadData()
                    unClaimedCollectionView.reloadData()
                    self.unClaimedCollectionView.setEmptyMessage("")
                     self.emptyImageBox.isHidden = false
                } else {
                     self.emptyImageBox.isHidden = true
                    self.unClaimedCollectionView.restore()
                }
            }
        } catch {
            
            
        }
        
    }

    
    /// This method is used to navigate to HomeViewController
    ///
    /// - Parameter sender: UIButton id
    @IBAction func goHoem(_ sender: UIButton) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier:AppConstants.Segue.Identifier.HomeViewController) as? HomeViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    

    
    
    
}
