

import UIKit

/// This is a custom uitableviewcell for reportsView
class ReportsTableViewCell: UITableViewCell {
    
    /// Indicate the color of the chart in uiimageview
    @IBOutlet weak var colorImg: UIImageView!
    
    /// Indicates the type of chart Expense / reimbursement
    @IBOutlet weak var typeLbl: UILabel!
    
    /// Shows the percentage value in the chart
    @IBOutlet weak var percentage: UILabel!
    
    /// Shows the amount value in the chart
    @IBOutlet weak var amount: UILabel!
    
    /// Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Sets the selected state of the cell, optionally animating the transition between states.
    ///
    /// - Parameters:
    ///   - selected: true to set the cell as selected, false to set it as unselected. The default is false.
    ///   - animated: true to animate the transition between selected states, false to make the transition immediate.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
