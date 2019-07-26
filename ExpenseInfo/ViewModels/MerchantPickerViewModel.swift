//
//  MerchantPickerViewModel.swift
//  ExpenseInfo
//
//  Created by lw-dlf on 4/12/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import Foundation

/// ViewModel class of `SearchAndFindMerchantPicker`
class MerchantPickerViewModel {
    
    /// searchActive sets bool value
    var searchActive : Bool = false
    
    /// filteredArray is after the predicate value
    var filteredArray:[[String:AnyObject]] = []
    
    /// dataArray has the required data for the uitableview
    var dataArray = [[String:AnyObject]]()
    
    /// dataTypeString
    var dataTypeStr = ""
    
    /// Delegate content array after selection of the merchant
    var selectedData:[String:AnyObject]!
    
    /// after done button is tapped
    var doneButtonTapped: (([String:AnyObject])->())?
    
    
    /// Clear the selected rows and remain unselected 
    func clearSelection() {
        
        var tempDataArray = [[String:AnyObject]]()
        for i in 0..<self.dataArray.count {
            var data = self.dataArray[i]
            data.updateValue(0 as AnyObject, forKey: AppConstants.Defaults.Key.unselected)
            tempDataArray.append(data)
        }
        self.dataArray = tempDataArray
        
    }
    
    
}
