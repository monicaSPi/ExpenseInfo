//
//  ExpenseDetailsViewModel.swift
//  ExpenseInfo
//
//  Created by lw-dlf on 4/12/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import Foundation
import WSTagsField
import UIKit

/// ViewModel class of `ExpenseDetailsViewController`
class ExpenseDetailsViewModel {
    // MARK: - Local variable
    
    /// Instance for a Data structure containing information about Expense List
    var expenseListArray = ExpenseListInfo()
    
    // MARK: - File private
    
     /// This is a scrollView to append tags in it
     let tagsField = WSTagsField()
}
