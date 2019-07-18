//
//  HomeViewModel.swift
//  ExpenseInfo
//
//  Created by lw-dlf on 4/10/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import Foundation
import CoreData
import UIKit


/// ViewModel class of `HomeViewController`
class HomeViewModel {
    
    
    /// global currency symbol instance variable
    var globalCurrencySymbol : String = ""
    
    /// expenseValueBlock a double-precision, floating-point value type.
    var expenseValueBlock : Double = 0.0
    
    /// claimedValueBloak a double-precision, floating-point value type.
    var claimedValueBlock : Double = 0.0
    
    /// unclaimedValueBlock a double-precision, floating-point value type.
    var unclaimedValueBlock : Double = 0.0
    

    
    // MARK: - Get List
    
    /**
     - get claimed list from the coredata entity using a predication of isClaimed = 'CL' as parameter
     - sum up the amount from the fetchResult and assign the value to claimedValueBlock variable
     
     - get claimed list from the coredata entity using a predication of isClaimed = 'NC' as parameter
     - sum up the amount from the fetchResult and assign the value to unclaimedValueBlock variable
     */
    func getClaimedandUnclaimedList() {
        
        
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch.predicate = NSPredicate(format: "isClaimed == %@ ","CL")
        
        do {
            let fetchedtype = try AppConstants.managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            
            if fetchedtype.count > 0 {
                
                
                fetchedtype.forEach { (exp) in
                    if let myString : String = exp.amount {
                        let myFloat = (myString as NSString).doubleValue
                        
                        self.claimedValueBlock += myFloat
                    }
                }
            }
            
            
        } catch {
            
            
        }
        
        
        let typefetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch1.predicate = NSPredicate(format: "isClaimed == %@ ","NC")
        
        do {
            let fetchedtype1 = try AppConstants.managedObjectContext.fetch(typefetch1) as! [ExpenseContent]
            
            if fetchedtype1.count > 0 {
                
                fetchedtype1.forEach { (exp) in
                    if let myString : String = exp.amount {
                        let myFloat = (myString as NSString).doubleValue
                        
                        self.unclaimedValueBlock += myFloat
                    }
                }
            }
            
        } catch {
            
            
        }
        
    }
    
    // MARK: - Update
    
    /**
     /// This function is used to update the Expense block
     - get expense list from the coredata entity 
     - sum up the amount from the fetchResult and assign the value to claimedValueBlock variable

     */
    func updateExpenseBlocks() {
        
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        do {
            let fetchedtype = try AppConstants.managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            
            if fetchedtype.count > 0 {
                
                
                fetchedtype.forEach { (exp) in
                    if let myString : String = exp.amount {
                        let myFloat = (myString as NSString).doubleValue
                        
                        self.expenseValueBlock += myFloat
                    }
                }
                
            } else {
                
                
            }
        } catch {
            print(error)
        }
    }
}
