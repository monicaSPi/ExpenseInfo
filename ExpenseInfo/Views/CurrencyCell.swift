import UIKit

/// This custom tableview cell is used to display the currency
final class CurrencyTableViewCell: UITableViewCell {
    
    /// This identifier is unique name of the CurrencyTableView
    static let identifier = String(describing: CurrencyTableViewCell.self)
    
    /// Initializes a table cell with a style and a reuse identifier and returns it to the caller.
    ///
    /// - Parameters:
    ///   - style: A constant indicating a cell style. See UITableViewCell.CellStyle for descriptions of these constants.
    ///   - reuseIdentifier: A string used to identify the cell object if it is to be reused for drawing multiple rows of a table view. Pass nil if the cell object is not to be reused. You should use the same reuse identifier for all cells of the same form.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = nil
        contentView.backgroundColor = nil
    }
    /// Returns an object initialized from data in a given unarchiver.
    ///
    /// - Parameter aDecoder: An unarchiver object.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// This will Lays out subviews.
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// Sets the selected state of the cell, optionally animating the transition between states.
    ///
    /// - Parameters:
    ///   - selected: true to set the cell as selected, false to set it as unselected. The default is false.
    ///   - animated: true to animate the transition between selected states, false to make the transition immediate.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}


/// This custom table view cell is used for MerchantListTableView
final class StoreTableViewCell: UITableViewCell {
    
    /// his identifier is unique name of the StoreTableView
    static let identifier = String(describing: StoreTableViewCell.self)
    
    /// Initializes a table cell with a style and a reuse identifier and returns it to the caller.
    ///
    /// - Parameters:
    ///   - style: A constant indicating a cell style. See UITableViewCell.CellStyle for descriptions of these constants.
    ///   - reuseIdentifier: A string used to identify the cell object if it is to be reused for drawing multiple rows of a table view. Pass nil if the cell object is not to be reused. You should use the same reuse identifier for all cells of the same form.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = nil
        contentView.backgroundColor = nil
    }
    /// Returns an object initialized from data in a given unarchiver.
    ///
    /// - Parameter aDecoder: An unarchiver object.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// This will Lays out subviews.
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// Sets the selected state of the cell, optionally animating the transition between states.
    ///
    /// - Parameters:
    ///   - selected: true to set the cell as selected, false to set it as unselected. The default is false.
    ///   - animated: true to animate the transition between selected states, false to make the transition immediate.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
