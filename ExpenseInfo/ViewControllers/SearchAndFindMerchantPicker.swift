
import Foundation
import UIKit


/// This ViewController helps to get the default Merchant list from the plist and populate in a list
class SearchAndFindMerchantPicker : UIViewController {
    
    // MARK: IBOutlet Properties
    
    /// backgroundView is used to create a blur effect when the list is poped in
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            
            backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(tapGestureRecognizer:)))
            backgroundView.isUserInteractionEnabled = true
            backgroundView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    /// searchBar is placed in the top of uitableview as a headerview
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.placeholder = "Search \(merchantPickerViewModel.dataTypeStr)"
            self.searchBar.setTextColor(color: .black)
            self.searchBar.setPlaceholderTextColor(color: .black)
            self.searchBar.setTextFieldColor(color: .clear)
            self.searchBar.setSearchImageColor(color: .black)
            self.searchBar.setTextFieldClearButtonColor(color: .black)
        }
    }
    
    /// A view that presents data using rows arranged in a single column.
    @IBOutlet weak var tableView: UITableView!
    
    /// An object that manages the content for a rectangular area on the screen. where the view is customized to get the corner radius curves
    @IBOutlet weak var centerView: UIView! {
        didSet {
            centerView.layer.cornerRadius = 10;
            centerView.layer.masksToBounds = true;
            centerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
                self.centerView.transform = .identity
            }, completion: {(finished: Bool) -> Void in
                // do something once the animation finishes, put it here
            })
        }
    }
    
    // MARK: - Local variables
    
    /// instance of MerchantPickerViewModel
    let merchantPickerViewModel = MerchantPickerViewModel()
    
    
    // MARK: Default View Controller Methods
    /// Called after the controller's view is loaded into memory.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        merchantPickerViewModel.clearSelection()
        tableView.reloadData()
    }
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    ///
    /// - Parameter animated: If true, the view is being added to the window using an animation.
    /** */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    ///
    /// - Parameter animated: If true, the disappearance of the view is being animated.
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - Picker Action
    
    /// Creates a custom picker with its data array and type string
    ///
    /// - Parameters:
    ///   - dataArray: dataArray to be loaded in the picker
    ///   - typeStr: typeStr as "Data"
    /// - Returns: return SearchAndFindMerchantPicker ViewController
    static func createPicker(dataArray: [[String:AnyObject]], typeStr : String) -> SearchAndFindMerchantPicker {
        let newViewController = UIStoryboard(name: AppConstants.XIB.Names.SearchStoryBoard, bundle: nil).instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.SearchAndFindMerchantPicker) as! SearchAndFindMerchantPicker
        newViewController.merchantPickerViewModel.dataArray = dataArray
        newViewController.merchantPickerViewModel.dataTypeStr = typeStr
        return newViewController
    }
    
    /// This method is called when the background is tapped and it will dismiss the picker and view is end editing
    ///
    /// - Parameter tapGestureRecognizer: tapGestureRecognizer for the view
    @objc func backgroundTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    //MARK: - Button Actions
    
    /// After the selection is made in the picker , this bottom is pressed this conforms the selection and will set the delegate values
    ///
    /// - Parameter sender: sender id
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        guard (merchantPickerViewModel.selectedData) != nil else {
            print("Select \(merchantPickerViewModel.dataTypeStr)")
            return
        }
        merchantPickerViewModel.doneButtonTapped?(merchantPickerViewModel.selectedData)
        self.close()
    }
    
    /// This is the action to dismiss the picker without any selection
    ///
    /// - Parameter sender: sender id
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.close()
    }
    
    
    // MARK: Custom Methods
    
    /// Show the Picker method
    ///
    /// - Parameter vc: viewController in which the picker should be injected
    func show(vc:UIViewController) {
        vc.addChild(self)
        vc.view.addSubview(self.view)
    }
    
    /// Picker Close or dismiss action
    func close() {
        centerView.transform = .identity
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.centerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
            self.centerView.isHidden = true
        })
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    
    
}

// MARK: - UISearchBarDelegate
extension SearchAndFindMerchantPicker : UISearchBarDelegate {
    
    /// Tells the delegate when the user begins editing the search text.
    ///
    /// - Parameter searchBar: The search bar that is being edited.
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        merchantPickerViewModel.searchActive = true;
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    /// Tells the delegate that the user finished editing the search text.
    ///
    /// - Parameter searchBar: The search bar that is being edited.
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        merchantPickerViewModel.searchActive = false;
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    /// Tells the delegate that the cancel button was tapped.
    ///
    /// - Parameter searchBar: The search bar that was tapped.
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        merchantPickerViewModel.searchActive = false;
        self.view.endEditing(true)
        tableView.reloadData()
    }
    
    /// Tells the delegate that the search button was tapped.
    ///
    /// - Parameter searchBar: The search bar that was tapped.
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        merchantPickerViewModel.searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    /// Tells the delegate that the user changed the search text.
    ///
    /// - Parameters:
    ///   - searchBar: The search bar that is being edited.
    ///   - searchText: The current text in the search text field.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        merchantPickerViewModel.filteredArray = merchantPickerViewModel.dataArray.filter ({ (data) -> Bool in
            if let tmp = data["name"] as? NSString {
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            }
            return false
        })
        
        merchantPickerViewModel.searchActive = merchantPickerViewModel.filteredArray.count == 0 ? false : true
        self.tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension SearchAndFindMerchantPicker: UITableViewDataSource {
    /// Asks the data source to return the number of sections in the table view.
    ///
    /// - Parameter tableView: An object representing the table view requesting this information.
    /// - Returns: The number of sections in tableView.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Tells the data source to return the number of rows in a given section of a table view.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - section: An index number identifying a section in tableView.
    /// - Returns: The number of rows in section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(merchantPickerViewModel.searchActive) {
            return merchantPickerViewModel.filteredArray.count
        }
        return merchantPickerViewModel.dataArray.count;
    }
    
    /// Asks the data source for a cell to insert in a particular location of the table view.
    ///
    /// - Parameters:
    ///   - tableView: A table-view object requesting the cell.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: An object inheriting from UITableViewCell that the table view can use for the specified row. UIKit raises an assertion if you return nil.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAndFindCell", for: indexPath) as? SearchAndFindCell {
            
            
            cell.labelName.text = merchantPickerViewModel.searchActive && merchantPickerViewModel.filteredArray.count > 0 ? merchantPickerViewModel.filteredArray[indexPath.row]["name"] as? String : merchantPickerViewModel.dataArray[indexPath.row]["name"] as? String
            if let unselected = merchantPickerViewModel.dataArray[indexPath.row]["unselected"] as? Int {
                cell.actionButton.isHidden = unselected == 0 ? true : false
            }
            return cell
        }
        return UITableViewCell()
    }
}
// MARK: -  UITableViewDelegate
extension SearchAndFindMerchantPicker :  UITableViewDelegate {
    
    
    
    /// Tells the delegate that the specified row is now selected.
    ///
    /// - Parameters:
    ///   - tableView: A table-view object informing the delegate about the new row selection.
    ///   - indexPath: An index path locating the new selected row in tableView.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        merchantPickerViewModel.clearSelection()
        tableView.reloadData()
        if let cell = tableView.cellForRow(at: indexPath) as? SearchAndFindCell {
            cell.actionButton.isHidden = false
            merchantPickerViewModel.selectedData = (merchantPickerViewModel.searchActive && merchantPickerViewModel.filteredArray.count > 0) ? merchantPickerViewModel.filteredArray[indexPath.row] : merchantPickerViewModel.dataArray[indexPath.row]
            
        }
    }
}

// MARK: - SearchAndFindMerchantPicker
extension SearchAndFindMerchantPicker {
    
    /// This method is used to show keyboard and set the view to move up
    @objc func keyBoardWillShow() {
        self.view.frame.origin.y >= 0 ? setViewMovedUp(movedUp: true) : setViewMovedUp(movedUp: false)
    }
    
    /// This method is used to hide keyboard and set the view to move down to original frame
    @objc func keyBoardWillHide() {
        
        self.view.frame.origin.y >= 0 ? setViewMovedUp(movedUp: true) : setViewMovedUp(movedUp: false)
        
    }
    
    /// This method is used to set the View up or set the view to its original position
    ///
    /// - Parameter movedUp: true or false based on the keyboard status
    func setViewMovedUp(movedUp: Bool){
        
        let kOffset:CGFloat = 80.0
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        var rect = self.view.frame
        
        if movedUp {
            rect.origin.y -= kOffset;
            rect.size.height += kOffset;
        }
        else
        {
            rect.origin.y += kOffset;
            rect.size.height -= kOffset;
        }
        self.view.frame = rect;
        UIView.commitAnimations()
    }
    
}

