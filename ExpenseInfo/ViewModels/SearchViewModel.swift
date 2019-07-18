//
//  SearchViewModel.swift
//  ExpenseInfo
//
//  Created by lw-dlf on 4/12/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

/// ViewModel class of `SearchViewController`
class SearchViewModel {
    // MARK: - Local variable
    
    /// Instance for a Data structure containing information about Expense List

    var expenseListArray = [ExpenseListInfo]()
    
    /// Instance for a Data structure containing information about Expense List after filter

    var filtered = [ExpenseListInfo]()
    
    /// <#Description#>
    var searchActive : Bool = false
    
    // MARK: - File Private
    
     /// <#Description#>
     let cellId = "ExpenseCell"
    
     /// <#Description#>
     let itemHeight: CGFloat = 90
    
     /// <#Description#>
     let xInset: CGFloat = 10
    
     /// <#Description#>
     let topInset: CGFloat = 10
}
