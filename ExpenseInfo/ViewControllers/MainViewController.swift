

import UIKit



/// This viewcontroller is the heart of the application likely dashboard
class MainViewController: UIViewController {
    
    
    // MARK: IBOutlet Properties
    
    /// optionsView that manages the content for a rectangular area on the screen.
    @IBOutlet weak var optionsView: UIView!
    
    /// topBar that manages the content for a top rectangular area on the screen.
    @IBOutlet weak var topBar: UIView!
    
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
    
    /// menuButton that executes your custom code in response to user interactions.
    @IBOutlet weak var menuButton: UIButton! {
        didSet {
            menuButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            menuButton.layer.shadowOffset = CGSize(width: 0, height: 3)
            menuButton.layer.shadowOpacity = 1.0
            menuButton.layer.shadowRadius = 10.0
            menuButton.layer.masksToBounds = false
        }
    }
    
    /// bottomView manages the content for a rectangular area on the screen.
    @IBOutlet weak var bottomView: UIView!
    
    /// blackView manages the content for a rectangular area on the screen.
    @IBOutlet weak var blackView: UIView!
    
    /// scrollView that allows the scrolling and zooming of its contained views.
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// stack1 an interface for laying out a collection of views in either a column or a row.
    @IBOutlet weak var stack1: UIStackView!
    
    /// stack2 an interface for laying out a collection of views in either a column or a row.
    @IBOutlet weak var stack2: UIStackView!
    
    // MARK: - Local variables
    
    /// Instance of MainViewModel
    let mainViewModel = MainViewModel()
    
    
    // MARK: Default View Controller Methods
    /// Called after the controller's view is loaded into memory.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainViewModel.isMenuActive = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.someActionToBePerformed), name: NSNotification.Name(rawValue: "myNotification"), object: nil)
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        
        
        
    }
    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    ///
    /// - Parameter animated: If true, the disappearance of the view is being animated.
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stack1.isHidden = false
        self.stack2.isHidden = false
        menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
        hideMenu()
        
        mainViewModel.isMenuActive = false
    }
    
    /// Notifies the view controller that its view was added to a view hierarchy.
    ///
    /// - Parameter animated: If true, the view was added to the window using an animation.
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: IBAction Methods
    
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
        let cameraPicker = UIStoryboard(name: AppConstants.XIB.Names.MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: "camera")
        self.present(cameraPicker, animated: true, completion: nil)
    }
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    ///
    /// - Parameter animated: If true, the view is being added to the window using an animation.
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    /// This method dismiss the current viewcontroller from the stack
    ///
    /// - Parameter sender: sender id
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /// This method is used to save the all entered details of the new expense manually
    ///
    /// - Parameter sender: sender id
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        
        let imageVC : AddNewExpenseViewController = self.children[0] as! AddNewExpenseViewController
        
        imageVC.addnewExpenseNow()
        
    }
    
    /// When menu is pressed from the bottom bar it opens the optionsView and should change the value of isMenuActive Value
    ///
    /// - Parameter sender: menuButton id
    @IBAction func menuButtonAction(_ sender: UIButton) {
        
        if mainViewModel.isMenuActive {
            menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
            
        } else {
            menuButton.setImage(UIImage(named: "retakeButton"), for: .normal)
            
        }
        self.blackView.isHidden = mainViewModel.isMenuActive ? true : false
        self.stack1.isHidden = mainViewModel.isMenuActive ? false : true
        self.stack2.isHidden = mainViewModel.isMenuActive ? false : true
        mainViewModel.isMenuActive  = mainViewModel.isMenuActive ? false : true
        
        
    }
    // MARK: Custom Methods
    
    /// Hide Options Menu
    func hideMenu() {
        self.blackView.isHidden = true
        self.optionsView.isHidden = true
    }
    
    /// Show Options Menu
    func showMenu() {
        
        
        self.blackView.isHidden = false
        self.optionsView.isHidden = false
        
    }
    
    
    
    
    /// This method is used to fetch the Merchant list from the Retail.plist and update the MerchantPicker with the respective delegates
    @objc func someActionToBePerformed () {
        // this will be called when hashTag is changed
        // do something when hashTag is changed
        var myEnglishArray: [String] = []
        if let URL = Bundle.main.url(forResource: "Retail", withExtension: "plist") {
            if let englishFromPlist = NSArray(contentsOf: URL) as? [String] {
                myEnglishArray = englishFromPlist
            }
        }
        
        
        var dataList = [[String:AnyObject]]()
        
        
        
        myEnglishArray.forEach { (i) in
            dataList.append(["id":NSNumber(integerLiteral: 1+1), "name":"\(i)" as AnyObject])
        }
        let searchPicker = SearchAndFindMerchantPicker.createPicker(dataArray: dataList , typeStr: "Data")
        addChild(searchPicker)
        self.view.addSubview(searchPicker.view)
        searchPicker.didMove(toParent: self)
        searchPicker.merchantPickerViewModel.doneButtonTapped =  { selectedData in
            print(selectedData)
            
            if let name = selectedData["name"] as? String {
                // no error
                let imageVC : AddNewExpenseViewController = self.children[0] as! AddNewExpenseViewController
                imageVC.updatenewMerchant(merchantName: name)
            }
            
        }
    }
    
    
    
    
    
}
