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
    
    /// collectionView contentInset itemHeight
    let itemHeight: CGFloat = 90
    //    private let lineSpacing: CGFloat = 8
    
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
            return 7
        }
    }
    
    /// This uinque identifier of the Expense Cell Collection view cell
    let cellId1 = "ExpenseCell"
    
    /// This uinque identifier of the Expense Cell Collection view cell
    let cellId2 = "ExpenseCell"
    
    /// This uinque identifier of the Expense Cell Collection view cell
    let cellId3 = "ExpenseCell"
    
    /// This is the value of xInset of the expense cell
    let xInset: CGFloat = 10
    
    /// This is the value of topInset of the expense cell
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
