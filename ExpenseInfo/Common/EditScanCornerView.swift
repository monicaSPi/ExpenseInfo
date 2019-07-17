

import UIKit

/// A UIView used by corners of a quadrilateral that is aware of its position.

final class EditScanCornerView: UIView {
    
    /// Instance for a CornerPosition
    let position: CornerPosition
    
    /// The image to display when the corner view is highlighted.
    private var image: UIImage?

    /// If it is highlighted true or false
    private(set) var isHighlighted = false
    
    
    /// circleLayer is used to edit the CAShapeLayer with fillColor, strokeColor with white and line width as 1
    lazy private var circleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 1.0
        return layer
    }()
    
    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    ///
    /// - Parameters:
    ///   - frame: frame size in CGRect
    ///   - position: corner position
    init(frame: CGRect, position: CornerPosition) {
        self.position = position
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = true
        layer.addSublayer(circleLayer)
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
        layer.cornerRadius = bounds.width / 2.0
    }
    
    /// Draws the receiver’s image within the passed-in rectangle.
    ///
    /// - Parameter rect: The portion of the view’s bounds that needs to be updated. The first time your view is drawn, this rectangle is typically the entire visible bounds of your view. However, during subsequent drawing operations, the rectangle may specify only part of your view.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let bezierPath = UIBezierPath(ovalIn: rect.insetBy(dx: circleLayer.lineWidth, dy: circleLayer.lineWidth))
        circleLayer.frame = rect
        circleLayer.path = bezierPath.cgPath
        
        image?.draw(in: rect)
    }
    
    /// This method is called when the corner view is highlighed with image and also set the isHighlighted as true
    ///
    /// - Parameter image: highlight image
    func highlightWithImage(_ image: UIImage) {
        isHighlighted = true
        self.image = image
        self.setNeedsDisplay()
    }
    
    /// This method is used to reset the view and set isHighlighted as false and remove image and set as nil
    func reset() {
        isHighlighted = false
        image = nil
        setNeedsDisplay()
    }
    
}
