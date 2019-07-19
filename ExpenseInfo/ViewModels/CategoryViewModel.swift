//
//  CategoryViewModel.swift
//  ExpenseInfo
//
//  Created by lw-dlf on 4/12/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import Foundation
import UIKit

/// ViewModel class of `ExpenseCategoryViewController`
class CategoryViewModel {
    // MARK: - Local variable
    
    /// <#Description#>
    var cate = ExpenseCategory()
    
    /// 
    weak var delegate: CategoryInfoDelegate? = nil
    
    /// <#Description#>
    var callback : ((String) -> Void)?
    
    /// <#Description#>
    var expenseCategory = [ExpenseCategory]()
    
    /// A view controller that manages the display of search results based on interactions with a search bar.
    var resultSearchController = UISearchController()
    
     /// <#Description#>
     let cellId = "categoryCell"
}
