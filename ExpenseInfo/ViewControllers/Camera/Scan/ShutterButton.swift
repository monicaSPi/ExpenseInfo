

import UIKit

/// A simple button used for the shutter.
final class ShutterButton: UIControl {
    
    /// outerRing layer instance of the shutter button
    private let outterRingLayer = CAShapeLayer()
    
    /// innerRing layer instance of the shutter button
    private let innerCircleLayer = CAShapeLayer()
    
    /// outerRing ratio instance of the shutter button in `CGFloat`
    private let outterRingRatio: CGFloat = 0.80
    
    /// innerRing ratio instance of the shutter button in `CGFloat`
    private let innerRingRatio: CGFloat = 0.75
    
    /// <#Description#>
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    /// A Boolean value indicating whether the control draws a highlight.
    override var isHighlighted: Bool {
        didSet {
            if oldValue != isHighlighted {
                animateInnerCircleLayer(forHighlightedState: isHighlighted)
            }
        }
    }
    
    // MARL: Life Cycle
    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(outterRingLayer)
        layer.addSublayer(innerCircleLayer)
        backgroundColor = .clear
        isAccessibilityElement = true
        accessibilityTraits = UIAccessibilityTraits.button
        impactFeedbackGenerator.prepare()
    }
    /// Returns an object initialized from data in a given unarchiver.
    ///
    /// - Parameter aDecoder: An unarchiver object.

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    /// Draws the receiver’s image within the passed-in rectangle.
    ///
    /// - Parameter rect: The portion of the view’s bounds that needs to be updated. The first time your view is drawn, this rectangle is typically the entire visible bounds of your view. However, during subsequent drawing operations, the rectangle may specify only part of your view.
    override func draw(_ rect: CGRect) {
        outterRingLayer.frame = rect
        outterRingLayer.path = pathForOutterRing(inRect: rect).cgPath
        outterRingLayer.fillColor = UIColor.white.cgColor
        outterRingLayer.rasterizationScale = UIScreen.main.scale
        outterRingLayer.shouldRasterize = true
        
        innerCircleLayer.frame = rect
        innerCircleLayer.path = pathForInnerCircle(inRect: rect).cgPath
        innerCircleLayer.fillColor = UIColor.white.cgColor
        innerCircleLayer.rasterizationScale = UIScreen.main.scale
        innerCircleLayer.shouldRasterize = true
    }
    
    // MARK: - Animation
    
    /// Animate inner circle layer
    ///
    /// - Parameter isHighlighted: A Boolean value indicating whether the control draws a highlight.
    private func animateInnerCircleLayer(forHighlightedState isHighlighted: Bool) {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        var values = [CATransform3DMakeScale(1.0, 1.0, 1.0), CATransform3DMakeScale(0.9, 0.9, 0.9), CATransform3DMakeScale(0.93, 0.93, 0.93), CATransform3DMakeScale(0.9, 0.9, 0.9)]
        if isHighlighted == false {
            values = [CATransform3DMakeScale(0.9, 0.9, 0.9), CATransform3DMakeScale(1.0, 1.0, 1.0)]
        }
        animation.values = values
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.duration = isHighlighted ? 0.35 : 0.10
        
        innerCircleLayer.add(animation, forKey: AppConstants.Defaults.Key.transform)
        impactFeedbackGenerator.impactOccurred()
    }
    
    // MARK: - Paths
    
    /// <#Description#>
    ///
    /// - Parameter rect: <#rect description#>
    /// - Returns: <#return value description#>
    private func pathForOutterRing(inRect rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(ovalIn: rect)
        
        let innerRect = rect.scaleAndCenter(withRatio: outterRingRatio)
        let innerPath = UIBezierPath(ovalIn: innerRect).reversing()
        
        path.append(innerPath)
        
        return path
    }
    
    /// <#Description#>
    ///
    /// - Parameter rect: <#rect description#>
    /// - Returns: <#return value description#>
    private func pathForInnerCircle(inRect rect: CGRect) -> UIBezierPath {
        let rect = rect.scaleAndCenter(withRatio: innerRingRatio)
        let path = UIBezierPath(ovalIn: rect)
        
        return path
    }
    
}
