//
//  ReimbursementReportViewModel.swift
//  ExpenseInfo
//
//  Created by lw-dlf on 6/24/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import UIKit
/// ViewModel class of `ReimburseReportViewController`
struct ReportItemViewModel {
    
    /// color of the chart
    var color: UIColor
    
    /// reimbursement type
    var type: String
    
    /// percentage from the overall amount to be reimbursed with the reimbursed amount in a double-precision, floating-point value type.
    var percentage: Double?
    
    /// reimbursement amount in a double-precision, floating-point value type.
    var amount: Double?
}





