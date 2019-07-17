

import UIKit
import CoreData

/// <#Description#>
class ExpenseCategoryViewController: UIViewController {
    // MARK: - ViewModel Variables
    
    /// <#Description#>
    let categoryViewModel = CategoryViewModel()
    // MARK: IBOutlet Properties
    
    /// <#Description#>
    @IBOutlet weak var bottomView: UIView!
    
    /// <#Description#>
    @IBOutlet weak var topBar: UIView!
    
    /// <#Description#>
    @IBOutlet weak var categoryCollection: UICollectionView! {
        didSet {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: categoryCollection.frame.width / 3  , height:  categoryCollection.frame.width / 3 )//CGSize(width: width / 3, height: width / 3)
            
            categoryCollection.delegate = self
            categoryCollection.dataSource = self
            
            categoryCollection.reloadData()
        }
    }
    
    /// <#Description#>
    @IBOutlet weak var searchBar: UISearchBar!
    
    /// <#Description#>
    @IBOutlet weak var categoryTableView: UITableView!
    

  
   
    
    // MARK: - View Initializatioln
    /// Called after the controller's view is loaded into memory.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryViewModel.cate.categoryId = "1"
        categoryViewModel.cate.categoryName = "Cloths"
        categoryViewModel.cate.categoryImg = "clothes"
        categoryViewModel.cate.categoryColor = "ff5252"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "2"
        categoryViewModel.cate.categoryName = "Food"
        categoryViewModel.cate.categoryImg = "food"
        categoryViewModel.cate.categoryColor = "455a64"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "3"
        categoryViewModel.cate.categoryName = "Health"
        categoryViewModel.cate.categoryImg = "health"
        categoryViewModel.cate.categoryColor = "ff4081"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "4"
        categoryViewModel.cate.categoryName = "Hotel"
        categoryViewModel.cate.categoryImg = "hotel"
        categoryViewModel.cate.categoryColor = "616161"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "5"
        categoryViewModel.cate.categoryName = "Party"
        categoryViewModel.cate.categoryImg = "party"
        categoryViewModel.cate.categoryColor = "e040fb"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "6"
        categoryViewModel.cate.categoryName = "Travel"
        categoryViewModel.cate.categoryImg = "Travel"
        categoryViewModel.cate.categoryColor = "5d4037"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "7"
        categoryViewModel.cate.categoryName = "Education"
        categoryViewModel.cate.categoryImg = "education"
        categoryViewModel.cate.categoryColor = "7c4dff"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "8"
        categoryViewModel.cate.categoryName = "Entertainment"
        categoryViewModel.cate.categoryImg = "entertainment"
        categoryViewModel.cate.categoryColor = "ff6e40"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "9"
        categoryViewModel.cate.categoryName = "Fitness"
        categoryViewModel.cate.categoryImg = "fitness"
        categoryViewModel.cate.categoryColor = "536dfe"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "10"
        categoryViewModel.cate.categoryName = "Gift"
        categoryViewModel.cate.categoryImg = "gift"
        categoryViewModel.cate.categoryColor = "ffd180"
        
       categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "11"
        categoryViewModel.cate.categoryName = "Labour"
        categoryViewModel.cate.categoryImg = "labour"
        categoryViewModel.cate.categoryColor = "40c4ff"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "12"
        categoryViewModel.cate.categoryName = "Loan"
        categoryViewModel.cate.categoryImg = "loan"
        categoryViewModel.cate.categoryColor = "ffd740"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "13"
        categoryViewModel.cate.categoryName = "Shop"
        categoryViewModel.cate.categoryImg = "shop"
        categoryViewModel.cate.categoryColor = "18ffff"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "14"
        categoryViewModel.cate.categoryName = "Sports"
        categoryViewModel.cate.categoryImg = "sports"
        categoryViewModel.cate.categoryColor = "eeff41"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "15"
        categoryViewModel.cate.categoryName = "Transport"
        categoryViewModel.cate.categoryImg = "transport"
        categoryViewModel.cate.categoryColor = "64ffda"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "16"
        categoryViewModel.cate.categoryName = "Utilities"
        categoryViewModel.cate.categoryImg = "utilities"
        categoryViewModel.cate.categoryColor = "b2ff59"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        categoryViewModel.cate.categoryId = "17"
        categoryViewModel.cate.categoryName = "Others"
        categoryViewModel.cate.categoryImg = "others"
        categoryViewModel.cate.categoryColor = "1b5e20"
        
        categoryViewModel.expenseCategory.append(categoryViewModel.cate)
        
        
        
        
  
        let imageSize = CGSize(width: 50 , height: 30)
        let headertitle = UILabel(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        
        headertitle.text = "Category"
        headertitle.textColor = .white
        headertitle.font = UIFont(name: "MyriadPro-Regular", size: 18)
        
        self.navigationItem.titleView = headertitle
        categoryCollection.reloadData()
    }
    // MARK: IBAction Methods
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
}

// MARK: - UICollectionViewDelegate
extension ExpenseCategoryViewController: UICollectionViewDelegate {
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - indexPath: <#indexPath description#>
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let value = categoryViewModel.expenseCategory[indexPath.row]//categNameArray[indexPath.row]
        categoryViewModel.delegate?.categoryInformation(name: value.categoryName!, image: value.categoryImg! , id: value.categoryId!, color: value.categoryColor!)
        self.dismiss(animated: true, completion: nil)
        
    }
}

// MARK: - UICollectionViewDataSource
extension ExpenseCategoryViewController: UICollectionViewDataSource {
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryViewModel.expenseCategory.count
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryViewModel.cellId, for: indexPath) as! CategoryCollectionViewCell
        let value = categoryViewModel.expenseCategory[indexPath.row]
        cell.catName.text = value.categoryName
        
        cell.catImage.image = UIImage(named: value.categoryImg!)
        
        
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension ExpenseCategoryViewController: UISearchBarDelegate {
    
}
