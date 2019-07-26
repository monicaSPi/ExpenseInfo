

import UIKit
import CoreData

/// Manages the searches made and display the search result list
class SearchViewController: UIViewController {
    // MARK: IBOutlet Properties
    
    /// emptyImageBox that displays a single image or a sequence of animated images in your interface. when there is nothing to show
    @IBOutlet weak var emptyImageBox: UIImageView!
    
    /// collectionView that manages an ordered collection of data items and presents them using customizable layouts.
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// A specialized view for receiving search-related information from the user.
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    // MARK: - ViewModel Variable
    
    /// Instance of SearchViewModel
    let searchViewModel = SearchViewModel()
    // MARK: - View Initializatioln
    /// Called after the controller's view is loaded into memory.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    ///
    /// - Parameter animated: If true, the view is being added to the window using an animation.
    
    override func viewWillAppear(_ animated: Bool) {
        let nib = UINib(nibName: searchViewModel.cellId, bundle: nil)
        collectionView.register( nib, forCellWithReuseIdentifier: searchViewModel.cellId)
        collectionView.contentInset.bottom = searchViewModel.itemHeight
        configureCollectionViewLayout()
        getExpenseList()
        
    }
    /// Notifies the view controller that its view was removed from a view hierarchy.
    ///
    /// - Parameter animated: If true, the disappearance of the view was animated.
    override func viewDidDisappear(_ animated: Bool) {
        searchBar.resignFirstResponder()
    }
    // MARK: - Custom Action
    
    /// This method is used to get the expense list from the core data and append the result in expenseListArray and the reaload the collectionView to populate the data
    func getExpenseList() {
        searchViewModel.expenseListArray = [ExpenseListInfo]()
        
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
                    addAcc.tags = exp.tags as? [String]
                    print(exp.tags as? [String] as Any)
                    addAcc.notes = exp.notes
                    if let expenseBill = exp.billImage  {
                        addAcc.billImg =  expenseBill
                    }
                    searchViewModel.expenseListArray.append(addAcc)
                }
            } else {
                if (searchViewModel.expenseListArray.count == 0) {
                } else {
                    self.collectionView.restore()
                }
            }
        } catch {
            
            
        }
        
        
    }
    
    /// This method is called while setting the collectionView Layout
    ///
    /// - Returns: returns the custom size based on the device model
    func lineSpacingValue() -> CGFloat {
        switch UIDevice.current.model {
        case "iPhone 4":
            return 8
        case "iPhone 5":
            return 8
        case "iPhone 6,7":
            return 15
        case "iPhone Plus":
            return 18
        default:
            return 8
        }
    }
    
    /// configure collection view layout
    private func configureCollectionViewLayout() {
        
        let lineSpacing: CGFloat = self.lineSpacingValue()
        
        guard let layout = collectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: searchViewModel.topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * searchViewModel.xInset
        layout.itemSize = CGSize(width: itemWidth, height: searchViewModel.itemHeight)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: IBAction Methods
    
    /// This method will dismiss the viewcontroller from the stack
    ///
    /// - Parameter sender: sender id
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    /// Tells the delegate that the user changed the search text.
    ///
    /// - Parameters:
    ///   - searchBar: The search bar that is being edited.
    ///   - searchText: The current text in the search text field.
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("didchange")
        
        if searchText.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                searchBar.resignFirstResponder()
            })
        }
        
        searchViewModel.filtered = searchViewModel.expenseListArray.filter {$0.merchantName?.range(of: searchText, options: [.anchored, .caseInsensitive, .diacriticInsensitive]) != nil }
        
        
        searchViewModel.searchActive = searchViewModel.filtered.count == 0 ? false : true
        self.collectionView.reloadData()
    }
    
    /// Tells the delegate when the user begins editing the search text.
    ///
    /// - Parameter searchBar: The search bar that is being edited.
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchViewModel.searchActive = true
        collectionView.reloadData()
    }
    
    /// Tells the delegate that the user finished editing the search text.
    ///
    /// - Parameter searchBar: The search bar that is being edited.
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchViewModel.searchActive = false
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    /// Tells the delegate that the cancel button was tapped.
    ///
    /// - Parameter searchBar: The search bar that was tapped.
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.searchActive = false
        collectionView.reloadData()
    }
    
    /// Tells the delegate that the search button was tapped.
    ///
    /// - Parameter searchBar: The search bar that was tapped.
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.searchActive = false
        collectionView.reloadData()
    }
    
}
// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    
    /// Tells the delegate that the item at the specified index path was selected.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view object that is notifying you of the selection change.
    ///   - indexPath: The index path of the cell that was selected.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ExpenseDetailsViewController) as? ExpenseDetailsViewController
        
        
        let share = searchViewModel.filtered[indexPath.row]
        vc2?.expenseDetailsViewModel.expenseListArray = share
        self.present(vc2!, animated: true)
        
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    
    
    /// Asks your data source object for the cell that corresponds to the specified item in the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - indexPath: The index path that specifies the location of the item.
    /// - Returns: A configured cell object. You must not return nil from this method.
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchViewModel.cellId, for: indexPath) as! ExpenseCell
        let share = searchViewModel.filtered[indexPath.row]
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
        print("indexPath \(indexPath.row) value : \(String(describing: share.tags))")
        if let shareTagss = share.tags  {
            cell.configureTags(value: shareTagss)
            cell.tagsView?.isHidden = false
        } else {
            cell.tagsView?.isHidden = true
            
        }
        
        
        cell.date.text =
        "\(share.date!) - \(share.time!)"
        
        return cell
    }
    
    /// Asks your data source object for the number of items in the specified section.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - section: An index number identifying a section in collectionView. This index value is 0-based.
    /// - Returns: The number of rows in section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (searchViewModel.filtered.count == 0) {
            self.collectionView.setEmptyMessage("")
            self.emptyImageBox.isHidden = false
        } else {
            self.emptyImageBox.isHidden = true
            self.collectionView.restore()
        }
        
        
        return searchViewModel.filtered.count
    }
}

