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
    
    /// This is the instance of Expenses
    var cate = ExpenseCategory()
    
    /// 
    weak var delegate: CategoryInfoDelegate? = nil
    
    /// This callback method is called when the target is achieved
    var callback : ((String) -> Void)?
    
    /// This is the instance of ExpenseCategory model
    var expenseCategory = [ExpenseCategory]()
    
    /// A view controller that manages the display of search results based on interactions with a search bar.
    var resultSearchController = UISearchController()
    
    /// This is the unique identifier of the category cell
    let cellId = "categoryCell"
}
