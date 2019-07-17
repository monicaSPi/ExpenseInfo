

import UIKit
import CoreData

/// <#Description#>
class ExpenseViewController: UIViewController  {
    //    func igcMenuSelected(_ selectedMenuName: String!, at index: Int) {
    //
    //    }
    
    // MARK: - ViewMode Variable
    
    /// <#Description#>
    let expenseViewModel = ExpenseViewModel()
    
    
    // MARK: IBOutlet Properties
    
    /// <#Description#>
    @IBOutlet weak var optionsView: UIView!
    
    /// <#Description#>
    @IBOutlet weak var shadowView: UIView!
    
    /// <#Description#>
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let nib = UINib(nibName: expenseViewModel.cellId, bundle: nil)
            collectionView.register( nib, forCellWithReuseIdentifier: expenseViewModel.cellId)
            collectionView.contentInset.bottom = expenseViewModel.itemHeight

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
    @IBOutlet weak var menuButton: UIButton! {
        didSet {
            menuButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            menuButton.layer.shadowOffset = CGSize(width: 0, height: 3)
            menuButton.layer.shadowOpacity = 1.0
            menuButton.layer.shadowRadius = 10.0
            menuButton.layer.masksToBounds = false
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var emptyImageBox: UIImageView!
    
    /// <#Description#>
    @IBOutlet weak var stack1: UIStackView!
    
    /// <#Description#>
    @IBOutlet weak var stack2: UIStackView!
    
    
   

    
    // MARK: IBAction Methods
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func menuButtonAction(_ sender: UIButton) {
        
        if expenseViewModel.isMenuActive {
            menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
            hideMenu()
            
        } else {
            menuButton.setImage(UIImage(named: "retakeButton"), for: .normal)
            
            self.showMenu()
        }
        
        
        
        self.stack1.isHidden = expenseViewModel.isMenuActive ? false : true
        self.stack2.isHidden = expenseViewModel.isMenuActive ? false : true
        expenseViewModel.isMenuActive = expenseViewModel.isMenuActive ? false : true
        
    }
    
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
    @IBAction func showActionSheet(_ sender: UIButton) {
        
        let customActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: AppConstants.alertActionStyle)
        
        let firstButton = UIAlertAction(title: "Low - High", style: .default, handler: { action in

            self.expenseViewModel.currentCheckedIndex = 0;
            self.expenseViewModel.expenseListArray = self.expenseViewModel.currentCheckedIndex == 0 ? self.expenseViewModel.expenseListArray.sorted(by: { $1.totalAmount > $0.totalAmount}) : self.expenseViewModel.expenseListArray.sorted(by: { $0.totalAmount > $1.totalAmount})
            self.collectionView.reloadData()
            
        })
        
        firstButton.setValue(UIColor.black, forKey: AppConstants.Defaults.Key.titleTextColor)
        firstButton.setValue(UIColor.black, forKey: AppConstants.Defaults.Key.imageTintColor)
       
        let secondButton = UIAlertAction(title: "High - Low", style: .default, handler: { action in
            //click action
            self.expenseViewModel.currentCheckedIndex = 1;
            self.expenseViewModel.expenseListArray = self.expenseViewModel.currentCheckedIndex == 0 ? self.expenseViewModel.expenseListArray.sorted(by: { $1.totalAmount > $0.totalAmount}) : self.expenseViewModel.expenseListArray.sorted(by: { $0.totalAmount > $1.totalAmount})
            self.collectionView.reloadData()
        })
        secondButton.setValue(UIColor.black, forKey: AppConstants.Defaults.Key.titleTextColor)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            //cancel
        })
        cancelButton.setValue(UIColor.black, forKey: AppConstants.Defaults.Key.titleTextColor)
        
        if expenseViewModel.currentCheckedIndex == 0 {
            firstButton.setValue(NSNumber(value: true), forKey: AppConstants.Defaults.Key.checked)
            secondButton.setValue(NSNumber(value: false), forKey: AppConstants.Defaults.Key.checked)

        } else if expenseViewModel.currentCheckedIndex == 1 {
            secondButton.setValue(NSNumber(value: true), forKey: AppConstants.Defaults.Key.checked)
            firstButton.setValue(NSNumber(value: false), forKey: AppConstants.Defaults.Key.checked)

        }
      
        customActionSheet.addAction(firstButton)
        customActionSheet.addAction(secondButton)
        customActionSheet.addAction(cancelButton)
        
        present(customActionSheet, animated: true)

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
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func goHoem(_ sender: UIButton) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier:AppConstants.Segue.Identifier.HomeViewController) as? HomeViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    
    // MARK: - Custom Action
    
    /// <#Description#>
    func hideMenu() {
        self.stack1.isHidden = false
        self.stack2.isHidden = false
        menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
        self.shadowView.isHidden = true
        self.optionsView.isHidden = true
        expenseViewModel.isMenuActive = false
    }
    
    /// <#Description#>
    func showMenu() {
        
        
        self.shadowView.isHidden = false
        self.optionsView.isHidden = false
        
        
    }
    
    
    
  
    
    /// <#Description#>
    private func configureCollectionViewLayout() {
        let lineSpacing: CGFloat = expenseViewModel.lineSpacingValue()
        
        guard let layout = collectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: expenseViewModel.topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * expenseViewModel.xInset
        layout.itemSize = CGSize(width: itemWidth, height: expenseViewModel.itemHeight)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
     /// This method is used to get the expense list from the core data and append the result in expenseListArray and the reaload the collectionView to populate the data
    func getExpenseList() {
        expenseViewModel.expenseListArray = [ExpenseListInfo]()
        
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        do {
            let fetchedtype = try AppConstants.managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            
            if fetchedtype.count > 0 {
                
                fetchedtype.forEach { (exp) in
                    var addAcc = ExpenseListInfo()
                    addAcc.merchantName = exp.merchantName
                    addAcc.amount = exp.amount
                    let myString = exp.amount
                    let myFloat = (myString! as NSString).doubleValue
                    if let expenseMode = exp.expenseMode {
                        addAcc.expenseMode = expenseMode
                    }
                    expenseViewModel.globalExpense += myFloat
                    addAcc.totalAmount = myFloat
                    
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
                    if let expensebill = exp.billImage  {
                        addAcc.billImg = expensebill
                    }
                    
                    expenseViewModel.expenseListArray.append(addAcc)
                }
                
                collectionView.reloadData()
            } else {
                if (expenseViewModel.expenseListArray.count == 0) {
                    collectionView.reloadData()
                    self.collectionView.setEmptyMessage("")
                    self.emptyImageBox.isHidden = false
                } else {
                    self.emptyImageBox.isHidden = true
                    self.collectionView.restore()
                }
            }
        } catch {
            
            
        }
        
        
    }
    
    
    // MARK: Default View Controller Methods
    /// Called after the controller's view is loaded into memory.
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        //    collectionView.setup()
        
    }
    
   
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    ///
    /// - Parameter animated: If true, the view is being added to the window using an animation.

    override func viewWillAppear(_ animated: Bool) {
        hideMenu()
        getExpenseList()
        configureCollectionViewLayout()
        
        
        
    }
    
    

    
    
    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    ///
    /// - Parameter animated: If true, the disappearance of the view is being animated.
    override func viewWillDisappear(_ animated: Bool) {
        self.stack1.isHidden = false
        self.stack2.isHidden = false
        menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
        
        
    }
    
    
    
    /// Notifies the view controller that its view was removed from a view hierarchy.
    ///
    /// - Parameter animated: If true, the disappearance of the view was animated.
    override func viewDidDisappear(_ animated: Bool) {
        print(expenseViewModel.globalExpense)
        UserDefaults.standard.set(expenseViewModel.globalExpense, forKey: AppConstants.Defaults.Key.GlobalExpense)
        UserDefaults.standard.synchronize()
        
        hideMenu()
        
        expenseViewModel.isMenuActive = false
    }
    
    // MARK: - ActionSheet Delegate

    
    
}


// MARK: - UICollectionViewDelegate
extension ExpenseViewController: UICollectionViewDelegate {
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - indexPath: <#indexPath description#>
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ExpenseDetailsViewController) as? ExpenseDetailsViewController
        
        
        let share = expenseViewModel.expenseListArray[indexPath.row]
        vc2?.expenseDetailsViewModel.expenseListArray = share
        self.present(vc2!, animated: true)
        
    }
}

// MARK: - UICollectionViewDataSource
extension ExpenseViewController: UICollectionViewDataSource {
    
    
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: expenseViewModel.cellId, for: indexPath) as! ExpenseCell
        let share = expenseViewModel.expenseListArray[indexPath.row]
        cell.clearCell()
        cell.merchantDetails.text = share.merchantName
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
        
        cell.categoryIcon.image = UIImage(data:share.categoryImg!)
        cell.amount.text = "\(share.currencySymbol!)\(share.amount!)"
    
        cell.claimedLbl.isHidden =  share.claimed! == "CL" ? false : true
        cell.tagsView = nil
        print("indexPath \(indexPath.row) value : \(String(describing: share.tags))")
        if let shareTagss = share.tags {
            cell.configureTags(value: shareTagss)
            cell.tagsView?.isHidden = false
        } else {
            cell.tagsView?.isHidden = true
            
        }
        
        
        cell.date.text =
        "\(share.date!)   \(share.time!)"
        
        return cell
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (expenseViewModel.expenseListArray.count == 0) {
            self.collectionView.setEmptyMessage("")
            self.emptyImageBox.isHidden = false
        } else {
            self.emptyImageBox.isHidden = true
            self.collectionView.restore()
        }
        
        
        return expenseViewModel.expenseListArray.count
    }
}

// MARK: - UICollectionView
extension UICollectionView {
    
    
    /// <#Description#>
    ///
    /// - Parameter message: <#message description#>
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    
    /// <#Description#>
    func restore() {
        self.backgroundView = nil
    }
}
