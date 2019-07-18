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
    
    /// <#Description#>
    weak var delegate: CategoryInfoDelegate? = nil
    
    /// <#Description#>
    var callback : ((String) -> Void)?
    
    /// <#Description#>
    var expenseCategory = [ExpenseCategory]()
    
    /// <#Description#>
    var resultSearchController = UISearchController()
    
     /// <#Description#>
     let cellId = "categoryCell"
}
