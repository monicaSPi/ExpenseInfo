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
    
    /// searchActive sets bool value
    var searchActive : Bool = false
    
    // MARK: - File Private
    
    /// This uinque identifier of the Expense Cell Collection view cell
    let cellId = "ExpenseCell"
    
    /// collectionView contentInset itemHeight
    let itemHeight: CGFloat = 90
    
    /// This is the value of xInset of the expense cell
    let xInset: CGFloat = 10
    
    /// This is the value of topInset of the expense cell
    let topInset: CGFloat = 10
}
