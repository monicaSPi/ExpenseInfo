

import UIKit
import CoreData

/// <#Description#>
class SearchViewController: UIViewController {
    // MARK: IBOutlet Properties
    
    /// <#Description#>
    @IBOutlet weak var emptyImageBox: UIImageView!
    
    /// <#Description#>
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// <#Description#>
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
             searchBar.delegate = self
        }
    }
    
    // MARK: - ViewModel Variable
    
    /// <#Description#>
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
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
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
    
    /// <#Description#>
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
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    

    
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - searchBar: <#searchBar description#>
    ///   - searchText: <#searchText description#>
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
    
    /// <#Description#>
    ///
    /// - Parameter searchBar: <#searchBar description#>
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchViewModel.searchActive = true
        collectionView.reloadData()
    }
    
    /// <#Description#>
    ///
    /// - Parameter searchBar: <#searchBar description#>
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchViewModel.searchActive = false
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    /// <#Description#>
    ///
    /// - Parameter searchBar: <#searchBar description#>
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.searchActive = false
        collectionView.reloadData()
    }
    
    /// <#Description#>
    ///
    /// - Parameter searchBar: <#searchBar description#>
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.searchActive = false
        collectionView.reloadData()
    }
    
}
// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - indexPath: <#indexPath description#>
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ExpenseDetailsViewController) as? ExpenseDetailsViewController
        
        
        let share = searchViewModel.filtered[indexPath.row]
        vc2?.expenseDetailsViewModel.expenseListArray = share
        self.present(vc2!, animated: true)
        
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
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
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
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

