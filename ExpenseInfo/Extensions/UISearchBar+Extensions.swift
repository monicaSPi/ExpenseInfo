import UIKit

// MARK: - UISearchBar Extension
extension UISearchBar {
    
    /// textField inside a `UISearchBar`
    var textField: UITextField? {
        return value(forKey: AppConstants.Defaults.Key.searchField) as? UITextField
    }
    
    
    
    /// getViewElement is a Generics for getting the elements present in the view
    ///
    /// - Parameter type: type T
    /// - Returns: element as T
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    /// This method gets the seachBarTextField
    ///
    /// - Returns: returns the viewable element in the textField
    func getSearchBarTextField() -> UITextField? {
        
        return getViewElement(type: UITextField.self)
    }
    
    /// Sets the TextColor for the `UISearchBar` textField
    ///
    /// - Parameter color: color for the text
    func setTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    /// Sets TextField background color
    ///
    /// - Parameter color: color for textField
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
    
    /// Sets textfield placeholder text color
    ///
    /// - Parameter color: placeholder text color
    func setPlaceholderTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
    
    /// Sets clear button background color
    ///
    /// - Parameter color: clear button color
    func setTextFieldClearButtonColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            
            let button = textField.value(forKey: AppConstants.Defaults.Key.clearButton) as! UIButton
            if (button.imageView?.image) != nil {
                //                button.setImage(image.transform(withNewColor: color), for: .normal)
            }
        }
    }
    
    /// Sets search icon image color
    ///
    /// - Parameter color: color for search image
    func setSearchImageColor(color: UIColor) {
        
        if (getSearchBarTextField()?.leftView as? UIImageView) != nil {
        }
    }
    
    /// Sets search icon as image
    ///
    /// - Parameter image: image for the seacrch
    func setSearchIcon(image: UIImage) {
        setImage(image, for: .search, state: .normal)
    }
    
    /// Sets clear custom icon image
    ///
    /// - Parameter image: image for clearIcon
    func setClearIcon(image: UIImage) {
        setImage(image, for: .clear, state: .normal)
    }
}
