import UIKit

// MARK: - UISearchBar Extension
extension UISearchBar {
    
    /// <#Description#>
    var textField: UITextField? {
        return value(forKey: AppConstants.Defaults.Key.searchField) as? UITextField
    }
    
    
    
    /// <#Description#>
    ///
    /// - Parameter type: <#type description#>
    /// - Returns: <#return value description#>
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func getSearchBarTextField() -> UITextField? {
        
        return getViewElement(type: UITextField.self)
    }
    
    /// <#Description#>
    ///
    /// - Parameter color: <#color description#>
    func setTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter color: <#color description#>
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            @unknown default:
                break
            }
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter color: <#color description#>
    func setPlaceholderTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter color: <#color description#>
    func setTextFieldClearButtonColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            
            let button = textField.value(forKey: AppConstants.Defaults.Key.clearButton) as! UIButton
            if (button.imageView?.image) != nil {
//                button.setImage(image.transform(withNewColor: color), for: .normal)
            }
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter color: <#color description#>
    func setSearchImageColor(color: UIColor) {
        
        if (getSearchBarTextField()?.leftView as? UIImageView) != nil {
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter image: <#image description#>
    func setSearchIcon(image: UIImage) {
        setImage(image, for: .search, state: .normal)
    }
    
    /// <#Description#>
    ///
    /// - Parameter image: <#image description#>
    func setClearIcon(image: UIImage) {
        setImage(image, for: .clear, state: .normal)
    }
}
