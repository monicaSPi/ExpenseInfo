

import UIKit
import WSTagsField

/// This custom uicollectionviewcell is used to display the expense made in a list
class ExpenseCell: UICollectionViewCell {
    
   
    /// This has merchant name and merchant details
    @IBOutlet weak var merchantDetails: UILabel!
    
    /// This contains the date of the expense
    @IBOutlet weak var date: UILabel!
    
    /// Helps to add n number of Tags for the expense
    @IBOutlet weak var tagsView: UIView?
    
    /// This is a scrollView to append tags in it
    fileprivate let tagsField = WSTagsField()
    
    
    /// Displays the selected category icon
    @IBOutlet weak var categoryIcon: UIImageView!
    
    /// Displays the text `Claimed` if the expense got reimbursed
    @IBOutlet weak var claimedLbl: UILabel!
    
    /// Displays the amount of the expense made
    @IBOutlet weak var amount: UILabel!
    
    /// Displays the image depends on the mode of expense either snap/upload/manual mode the expense is made
    @IBOutlet weak var modeImg: UIImageView!
    
    /// Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.masksToBounds = false
        layer.shadowRadius = 2
        tagsField.readOnly = true

        tagsField.layoutMargins = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
 tagsField.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
        

        tagsField.spaceBetweenTags = 10
        tagsField.backgroundColor = .clear
        tagsField.font = UIFont(name: "MyriadPro-Regular", size: 14.0)
        tagsField.textColor = UIColor(hexString: "84996A")//UIColor(hexString: "426891")
        tagsField.fieldTextColor = UIColor(hexString: "84996A")
        tagsField.selectedColor = UIColor(hexString: "DADEEB")
        tagsField.selectedTextColor = UIColor(hexString: "84996A")
        tagsField.tintColor = UIColor(hexString: "E6F3D6")
        tagsField.acceptTagOption = .space
    }
    
    /// This method is used to remove all the tags
    func clearCell () {
        self.tagsField.removeTags()
        //self.tagsView?.isHidden = true
    }
    
    /// This method is to configure tags with value of string array as parameter . Iterate the value from the string array with forEach and addTag to the tagsField
    ///
    /// - Parameter value: tags of type string array
    func configureTags(value : [String])  {
//        for val in value {
//            self.tagsField.addTag(val)
//        }
        value.forEach { (val) in
             self.tagsField.addTag(val)
        }
    }

    
    /// This method is used to format the double value with 2 disgits after decimal point and return as a string
    ///
    /// - Parameter val: gets the input value as double
    /// - Returns: after string format patter %0.2f it return as string
    private func twoDigitsFormatted(_ val: Double) -> String {
        return String(format: "%.0.2f", val)
    }
}
