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

     /// <#Description#>
     let cellId = "ExpenseCell"
    
     /// <#Description#>
     let itemHeight: CGFloat = 90
    
     /// <#Description#>
     let xInset: CGFloat = 10
    
     /// <#Description#>
     let topInset: CGFloat = 10
    
    /// globalExpense a double-precision, floating-point value type.
    var globalExpense : Double = 0.0
    
    /// <#Description#>
    var currentCheckedIndex = 2;
    
    /// Check for the option menus is active
    var isMenuActive = false
    
    /// <#Description#>
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
