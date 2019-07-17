//
//  MerchantPickerViewModel.swift
//  ExpenseInfo
//
//  Created by lw-dlf on 4/12/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import Foundation

/// <#Description#>
class MerchantPickerViewModel {
    
    /// <#Description#>
    var searchActive : Bool = false
    
    /// <#Description#>
    var filteredArray:[[String:AnyObject]] = []
    
    /// <#Description#>
    var dataArray = [[String:AnyObject]]()
    
    /// <#Description#>
    var dataTypeStr = ""
    
    /// <#Description#>
    var selectedData:[String:AnyObject]!
    
    /// <#Description#>
    var doneButtonTapped: (([String:AnyObject])->())?
    
    
    /// <#Description#>
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
