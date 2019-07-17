//
//  Constants.swift
//  ExpenseInfo
//
//  Created by lw-dlf on 4/10/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import Foundation
import UIKit

/// <#Description#>
struct AppConstants {
    
    /// <#Description#>
    static let alertActionStyle: UIAlertController.Style = .actionSheet
    
    /// <#Description#>
    static let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// <#Description#>
    struct XIB {
        static let Names = XIB()
        let Value = ""
        let MainStoryBoard = "Main"
        let SearchStoryBoard = "SearchAndFindMerchantPicker"
    }
    
    /// <#Description#>
    struct Segue {
        static let Identifier = Segue()
        let MainViewController = "MainViewController"
        let HomeViewController = "HomeViewController"
        let ReportsViewController = "ReportsViewController"
        let SearchAndFindMerchantPicker = "SearchAndFindMerchantPicker"
        let ReimbursementViewController = "ReimbursementViewController"
        let ExpenseViewController = "ExpenseViewController"
        let UploadViewController = "UploadViewController"
        let ScannerViewController = "ScannerViewController"
        let EditScanViewController = "EditScanViewController"
        let ExpenseDetailsViewController = "ExpenseDetailsViewController"
        let ExpenseCategoryViewController = "ExpenseCategoryViewController"
    }
    
    /// <#Description#>
    struct Defaults {
         static let Key = Defaults()
        let AddExpenseType = "AddExpenseType"
        let Year = "Year"
        let Month = "Month"
        let CurrencySymbol = "CurrencySymbol"
        let CurrencyCode = "CurrencyCode"
        let path = "path"
        let image = "image"
        let titleTextColor = "titleTextColor"
        let attributedTitle = "attributedTitle"
        let attributedMessage = "attributedMessage"
        let contentViewController = "contentViewController"
        let searchField = "searchField"
        let clearButton = "clearButton"
        let unselected = "unselected"
        let DisplayImg = "DisplayImg"
        let ReceiptImg = "ReceiptImg"
        let expenseListArrayId = "expenseListArrayId"
        let imageTintColor = "imageTintColor"
        let checked = "checked"
        let GlobalExpense = "GlobalExpense"
        let transform = "transform"
        let Password = "Password"
    }
    
    /// <#Description#>
    struct Messages {
        static let detectionNoResultsMessage = "No results returned."
    }
}
