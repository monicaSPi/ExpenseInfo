//
//  ReimbursementViewModel.swift
//  ExpenseInfo
//
//  Created by lw-dlf on 4/12/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

/// ViewModel class of `ReimbursementViewController`
class ReimbursementViewModel {
    
     /// <#Description#>
     let itemHeight: CGFloat = 90
    //    private let lineSpacing: CGFloat = 8
    
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
            return 7
        }
    }
    
     /// <#Description#>
     let cellId1 = "ExpenseCell"
    
     /// <#Description#>
     let cellId2 = "ExpenseCell"
    
     /// <#Description#>
     let cellId3 = "ExpenseCell"
    
     /// <#Description#>
     let xInset: CGFloat = 10
    
     /// <#Description#>
     let topInset: CGFloat = 10
    
    /// Check for the option menus is active
    var isMenuActive = false
    
    /// Instance for a Data structure containing information about unClaimed List

    var unclaimedListArray = [ExpenseListInfo]()
    
    /// Instance for a Data structure containing information about Claimed List

    var claimedListArray = [ExpenseListInfo]()
    
    /// Instance for a Data structure containing information about Submitted List

    var submittedListArray = [ExpenseListInfo]()
}
