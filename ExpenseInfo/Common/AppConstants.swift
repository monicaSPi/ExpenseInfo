//
//  Constants.swift
//  ExpenseInfo
//
//  Created by lw-dlf on 4/10/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import Foundation
import UIKit

/// Data Structure which contains all the constants required for the application
struct AppConstants {
    
    /// UIAlertController Style constant
    static let alertActionStyle: UIAlertController.Style = .actionSheet
    
    /// Instance for ManagedObjectContext constant
    static let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// AppConstants hierarchy for Interface builder
    struct XIB {
        
        /// Static Name Singleton
        static let Names = XIB()
        
        /// Value
        let Value = ""
        
        /// Main Storyboard name
        let MainStoryBoard = "Main"
        
        /// Search StoryBoard name
        let SearchStoryBoard = "SearchAndFindMerchantPicker"
    }
    
    ///This data structure is to use segues to define the flow of your app’s interface. A segue defines a transition between two view controllers in your app’s storyboard file.
    struct Segue {
        
        /// Segue with Identifier Singleton
        static let Identifier = Segue()
        
        /// Segue Identifier for MainViewController
        let MainViewController = "MainViewController"
        
        /// Segue Identifier for HomeViewController
        let HomeViewController = "HomeViewController"
        
        /// Segue Identifier for ReportsViewController
        let ReportsViewController = "ReportsViewController"
        
        /// Segue Identifier for SearchAndFindMerchantPicker
        let SearchAndFindMerchantPicker = "SearchAndFindMerchantPicker"
        
        /// Segue Identifier for ReimbursementViewController
        let ReimbursementViewController = "ReimbursementViewController"
        
        /// Segue Identifier for ExpenseViewController
        let ExpenseViewController = "ExpenseViewController"
        
        /// Segue Identifier for UploadViewController
        let UploadViewController = "UploadViewController"
        
        /// Segue Identifier for ScannerViewController
        let ScannerViewController = "ScannerViewController"
        
        /// Segue Identifier for EditScanViewController
        let EditScanViewController = "EditScanViewController"
        
        /// Segue Identifier for ExpenseDetailsViewController
        let ExpenseDetailsViewController = "ExpenseDetailsViewController"
        
        /// Segue Identifier for ExpenseCategoryViewController
        let ExpenseCategoryViewController = "ExpenseCategoryViewController"
    }
    
    /// This Data structure is used to define the UserDefaults applied in the entire application
    struct Defaults {
        
        /// UserDefaults Key Singleton
        static let Key = Defaults()
        
        /// AddExpenseType UserDefaults Key
        let AddExpenseType = "AddExpenseType"
        
        /// Year UserDefaults Key
        let Year = "Year"
        
        /// Month UserDefaults Key
        let Month = "Month"
        
        /// CurrencySymbol UserDefaults Key
        let CurrencySymbol = "CurrencySymbol"
        
        /// CurrencyCode UserDefaults Key
        let CurrencyCode = "CurrencyCode"
        
        /// path UserDefaults Key
        let path = "path"
        
        /// image UserDefaults Key
        let image = "image"
        
        /// titleTextColor UserDefaults Key
        let titleTextColor = "titleTextColor"
        
        /// attributedTitle UserDefaults Key
        let attributedTitle = "attributedTitle"
        
        /// attributedMessage UserDefaults Key
        let attributedMessage = "attributedMessage"
        
        /// contentViewController UserDefaults Key
        let contentViewController = "contentViewController"
        
        /// searchField UserDefaults Key
        let searchField = "searchField"
        
        /// clearButton UserDefaults Key
        let clearButton = "clearButton"
        
        /// unselected UserDefaults Key
        let unselected = "unselected"
        
        /// DisplayImg UserDefaults Key
        let DisplayImg = "DisplayImg"
        
        /// ReceiptImg UserDefaults Key
        let ReceiptImg = "ReceiptImg"
        
        /// expenseListArrayId UserDefaults Key
        let expenseListArrayId = "expenseListArrayId"
        
        /// imageTintColor UserDefaults Key
        let imageTintColor = "imageTintColor"
        
        /// checked UserDefaults Key
        let checked = "checked"
        
        /// GlobalExpense UserDefaults Key
        let GlobalExpense = "GlobalExpense"
        
        /// transform UserDefaults Key
        let transform = "transform"
        
        /// Password UserDefaults Key
        let Password = "Password"
    }
    
    /// This Data Structure is used to send messages inside the application
    struct Messages {
        
        /// No result detected Static message
        static let detectionNoResultsMessage = "No results returned."
    }
}
