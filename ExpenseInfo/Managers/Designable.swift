import UIKit


/// Designable UIImageView
@IBDesignable class RoundImage: UIImageView {
    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    /// Returns an object initialized from data in a given unarchiver.
    ///
    /// - Parameter aDecoder: An unarchiver object.

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    /// Called when a designable object is created in Interface Builder.
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    /// This method refreshCorners with value for the corner radius
    func sharedInit() {
        refreshCorners(value: cornerRadiuss)
        
        // Common logic goes here
    }
    
    /// This method is to set corner radius
    ///
    /// - Parameter value: corner radius value in float
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    /// set corner radius value
    @IBInspectable var cornerRadiuss: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadiuss)
        }
    }
}

/// Designable UIButton
@IBDesignable class RoundButton: UIButton {
    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateLayerProperties()

        sharedInit()
    }
    
    /// This method is used to update layer properties to the UIButton
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
    }
    /// Returns an object initialized from data in a given unarchiver.
    ///
    /// - Parameter aDecoder: An unarchiver object.

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
   /// Called when a designable object is created in Interface Builder.
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
     /// This method refreshCorners with value for the corner radius
    func sharedInit() {
        refreshCorners(value: cornerRadiuss)
        
        // Common logic goes here
    }
    
    /// This method is to set corner radius
    ///
    /// - Parameter value: corner radius value in float
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    /// set corner radius value
    @IBInspectable var cornerRadiuss: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadiuss)
        }
    }
}

/// Designable UIView
@IBDesignable class RoundView: UIView {
    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    /// Returns an object initialized from data in a given unarchiver.
    ///
    /// - Parameter aDecoder: An unarchiver object.

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    /// Called when a designable object is created in Interface Builder.
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
     /// This method refreshCorners with value for the corner radius
    func sharedInit() {
        refreshCorners(value: cornerRadiuss)
        
        // Common logic goes here
    }
    
    /// This method is to set corner radius
    ///
    /// - Parameter value: corner radius value in float
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    /// set corner radius value
    @IBInspectable var cornerRadiuss: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadiuss)
        }
    }
}
