//
//  ExpenseViewModel.swift
//  ExpenseInfo
//
//  Created by lw-dlf on 4/12/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

/// ViewModel class of `ExpenseViewController`
class ExpenseViewModel {
    
    /// This uinque identifier of the Expense Cell Collection view cell
    let cellId = "ExpenseCell"
    
    /// This denotes the expense cell height
    let itemHeight: CGFloat = 90
    
    /// This is the value of xInset of the expense cell
    let xInset: CGFloat = 10
    
    /// This is the value of topInset of the expense cell
    let topInset: CGFloat = 10
    
    /// globalExpense a double-precision, floating-point value type.
    var globalExpense : Double = 0.0
    
    /// This is used to check the sorting order of the expense list
    var currentCheckedIndex = 2;
    
    /// Check for the option menus is active
    var isMenuActive = false
    
    /// This is the instance of expense list array
    var expenseListArray = [ExpenseListInfo]()
    
    
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
    
    
    
}
