

import UIKit
import WSTagsField

/// <#Description#>
class ExpenseCell: UICollectionViewCell {
    
   
    /// <#Description#>
    @IBOutlet weak var merchantDetails: UILabel!
    
    /// <#Description#>
    @IBOutlet weak var date: UILabel!
    
    /// <#Description#>
    @IBOutlet weak var tagsView: UIView?
    
    /// <#Description#>
    fileprivate let tagsField = WSTagsField()
    
    /// <#Description#>
    @IBOutlet weak var tagScroll: UIScrollView!
    
    /// <#Description#>
    @IBOutlet weak var categoryIcon: UIImageView!
    
    /// <#Description#>
    @IBOutlet weak var claimedLbl: UILabel!
    
    /// <#Description#>
    @IBOutlet weak var amount: UILabel!
    
    /// <#Description#>
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
    
    /// <#Description#>
    func clearCell () {
        self.tagsField.removeTags()
        //self.tagsView?.isHidden = true
    }
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    func configureTags(value : [String])  {
//        for val in value {
//            self.tagsField.addTag(val)
//        }
        value.forEach { (val) in
             self.tagsField.addTag(val)
        }
    }

    
    /// <#Description#>
    ///
    /// - Parameter val: <#val description#>
    /// - Returns: <#return value description#>
    private func twoDigitsFormatted(_ val: Double) -> String {
        return String(format: "%.0.2f", val)
    }
}
