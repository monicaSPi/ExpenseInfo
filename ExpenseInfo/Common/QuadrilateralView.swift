

import UIKit
import AVFoundation



/// Simple enum to keep track of the position of the corners of a quadrilateral.
///
/// - topLeft: indicate topLeft postion
/// - topRight: indicate topRight position
/// - bottomRight: indicate bottomRight position
/// - bottomLeft: indicate bottomLeft position
enum CornerPosition {
    case topLeft
    case topRight
    case bottomRight
    case bottomLeft
}


/// The `QuadrilateralView` is a simple `UIView` subclass that can draw a quadrilateral, and optionally edit it.
final class QuadrilateralView: UIView {
    
    /// Instance of `CAShapeLayer`
    private let quadLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = true
        
        return layer
    }()
    
    /// We want the corner views to be displayed under the outline of the quadrilateral.
    /// Because of that, we need the quadrilateral to be drawn on a UIView above them.
    private let quadView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// The quadrilateral drawn on the view.
    private(set) var quad: Quadrilateral?
    
    /// Editable Contraints is set
    public var editable = false {
        didSet {
            cornerViews(hidden: !editable)
            quadLayer.fillColor = editable ? UIColor(white: 0.0, alpha: 0.6).cgColor : UIColor(white: 1.0, alpha: 0.5).cgColor
            guard let quad = quad else {
                return
            }
            drawQuad(quad, animated: false)
            layoutCornerViews(forQuad: quad)
        }
    }
    
    /// Highlited contraints is set
    private var isHighlighted = false {
        didSet (oldValue) {
            guard oldValue != isHighlighted else {
                return
            }
            quadLayer.fillColor = isHighlighted ? UIColor.clear.cgColor : UIColor(white: 0.0, alpha: 0.6).cgColor
            isHighlighted ? bringSubviewToFront(quadView) : sendSubviewToBack(quadView)
        }
    }
    
    ///  topLeftCornerView used by a quadrilateral that is aware of its position.
    lazy private var topLeftCornerView: EditScanCornerView = {
        return EditScanCornerView(frame: CGRect(origin: .zero, size: cornerViewSize), position: .topLeft)
    }()
    
    ///  topRightCornerView used by a quadrilateral that is aware of its position.
    lazy private var topRightCornerView: EditScanCornerView = {
        return EditScanCornerView(frame: CGRect(origin: .zero, size: cornerViewSize), position: .topRight)
    }()
    
    ///  bottomRightCornerView used by a quadrilateral that is aware of its position.
    lazy private var bottomRightCornerView: EditScanCornerView = {
        return EditScanCornerView(frame: CGRect(origin: .zero, size: cornerViewSize), position: .bottomRight)
    }()
    
    ///  bottomLeftCornerView used by a quadrilateral that is aware of its position.
    lazy private var bottomLeftCornerView: EditScanCornerView = {
        return EditScanCornerView(frame: CGRect(origin: .zero, size: cornerViewSize), position: .bottomLeft)
    }()
    
    /// assign highlightedCornerViewSize in `CGSize`
    private let highlightedCornerViewSize = CGSize(width: 75.0, height: 75.0)
    
    /// assign cornerViewSize in `CGSize`
    private let cornerViewSize = CGSize(width: 20.0, height: 20.0)
    
    // MARK: - Life Cycle
    
    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    /// Returns an object initialized from data in a given unarchiver.
    ///
    /// - Parameter aDecoder: An unarchiver object.
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// This method is used to initialize the setup of cornerViews , Contraints, adding sublayers and adding quadView as subview
    private func commonInit() {
        addSubview(quadView)
        setupCornerViews()
        setupConstraints()
        quadView.layer.addSublayer(quadLayer)
    }
    
    /// This methods does the constraint setup for a quadView
    private func setupConstraints() {
        let quadViewConstraints = [
            quadView.topAnchor.constraint(equalTo: topAnchor),
            quadView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomAnchor.constraint(equalTo: quadView.bottomAnchor),
            trailingAnchor.constraint(equalTo: quadView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(quadViewConstraints)
    }
    
    /// This method adds all the CornerView as subview to the current View
    private func setupCornerViews() {
        addSubview(topLeftCornerView)
        addSubview(topRightCornerView)
        addSubview(bottomRightCornerView)
        addSubview(bottomLeftCornerView)
    }
    
    /// Lays out subviews.
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard quadLayer.frame != bounds else {
            return
        }
        
        quadLayer.frame = bounds
        if let quad = quad {
            drawQuadrilateral(quad: quad, animated: false)
        }
    }
    
    // MARK: - Drawings
    
    /// Draws the passed in quadrilateral.
    ///
    /// - Parameters:
    ///   - quad: The quadrilateral to draw on the view. It should be in the coordinates of the current `QuadrilateralView` instance.
    func drawQuadrilateral(quad: Quadrilateral, animated: Bool) {
        self.quad = quad
        drawQuad(quad, animated: animated)
        if editable {
            cornerViews(hidden: false)
            layoutCornerViews(forQuad: quad)
        }
    }
    
    /// This method is used to draw the path using `UIBezierPath` by checking some conditions if its editable or not
    ///
    /// - Parameters:
    ///   - quad: Instance represents quadrilateral and its position.
    ///   - animated: True if it can be animated
    private func drawQuad(_ quad: Quadrilateral, animated: Bool) {
        var path = quad.path
        
        if editable {
            path = path.reversing()
            let rectPath = UIBezierPath(rect: bounds)
            path.append(rectPath)
        }
        
        if animated == true {
            let pathAnimation = CABasicAnimation(keyPath: AppConstants.Defaults.Key.path)
            pathAnimation.duration = 0.2
            quadLayer.add(pathAnimation, forKey: AppConstants.Defaults.Key.path)
        }
        
        quadLayer.path = path.cgPath
        quadLayer.isHidden = false
    }
    
    /// This method layoutCornerViews based on the quad corners and set the values
    ///
    /// - Parameter quad: has quad corners
    private func layoutCornerViews(forQuad quad: Quadrilateral) {
        topLeftCornerView.center = quad.topLeft
        topRightCornerView.center = quad.topRight
        bottomLeftCornerView.center = quad.bottomLeft
        bottomRightCornerView.center = quad.bottomRight
    }
    
    /// This method removes the quadrilateral from the quadLayer path
    func removeQuadrilateral() {
        quadLayer.path = nil
        quadLayer.isHidden = true
    }
    
    // MARK: - Actions
    
    /// This method is to moveCorner and draw the updated quadrilateral
    ///
    /// - Parameters:
    ///   - cornerView: corners of a quadrilateral that is aware of its position
    ///   - point: specified points for the quadrilateral
    func moveCorner(cornerView: EditScanCornerView, atPoint point: CGPoint) {
        guard let quad = quad else {
            return
        }
        
        let validPoint = self.validPoint(point, forCornerViewOfSize: cornerView.bounds.size, inView: self)
        
        cornerView.center = validPoint
        let updatedQuad = update(quad, withPosition: validPoint, forCorner: cornerView.position)
        
        self.quad = updatedQuad
        drawQuad(updatedQuad, animated: false)
    }
    
    /// This method is used to highlight when the quad corener is pressed to change its position
    ///
    /// - Parameters:
    ///   - position: to keep track of the position of the corners of a quadrilateral.
    ///   - image: image captured / uploaded image
    func highlightCornerAtPosition(position: CornerPosition, with image: UIImage) {
        guard editable else {
            return
        }
        isHighlighted = true
        
        let cornerView = cornerViewForCornerPosition(position: position)
        guard cornerView.isHighlighted == false else {
            cornerView.highlightWithImage(image)
            return
        }
        
        let origin = CGPoint(x: cornerView.frame.origin.x - (highlightedCornerViewSize.width - cornerViewSize.width) / 2.0,
                             y: cornerView.frame.origin.y - (highlightedCornerViewSize.height - cornerViewSize.height) / 2.0)
        cornerView.frame = CGRect(origin: origin, size: highlightedCornerViewSize)
        cornerView.highlightWithImage(image)
    }
    
    /// This method resets the highlightedCornerViews and set to normal
    func resetHighlightedCornerViews() {
        isHighlighted = false
        resetHighlightedCornerViews(cornerViews: [topLeftCornerView, topRightCornerView, bottomLeftCornerView, bottomRightCornerView])
    }
    
    /// This method resets the multiple highlightedCornerViews and set to normal
    ///
    /// - Parameter cornerViews: Array of `EditScanCornerView`
    private func resetHighlightedCornerViews(cornerViews: [EditScanCornerView]) {
        cornerViews.forEach { (cornerView) in
            resetHightlightedCornerView(cornerView: cornerView)
        }
    }
    
    /// This method resets the  highlightedCornerViews and set to normal
    ///
    /// - Parameter cornerView: Instance of the `EditScanCornerView`
    private func resetHightlightedCornerView(cornerView: EditScanCornerView) {
        cornerView.reset()
        let origin = CGPoint(x: cornerView.frame.origin.x + (cornerView.frame.size.width - cornerViewSize.width) / 2.0,
                             y: cornerView.frame.origin.y + (cornerView.frame.size.height - cornerViewSize.width) / 2.0)
        cornerView.frame = CGRect(origin: origin, size: cornerViewSize)
        cornerView.setNeedsDisplay()
    }
    
    // MARK: Validation
    
    /// Ensures that the given point is valid - meaning that it is within the bounds of the passed in `UIView`.
    ///
    /// - Parameters:
    ///   - point: The point that needs to be validated.
    ///   - cornerViewSize: The size of the corner view representing the given point.
    ///   - view: The view which should include the point.
    /// - Returns: A new point which is within the passed in view.
    private func validPoint(_ point: CGPoint, forCornerViewOfSize cornerViewSize: CGSize, inView view: UIView) -> CGPoint {
        var validPoint = point
        
        if point.x > view.bounds.width {
            validPoint.x = view.bounds.width
        } else if point.x < 0.0 {
            validPoint.x = 0.0
        }
        
        if point.y > view.bounds.height {
            validPoint.y = view.bounds.height
        } else if point.y < 0.0 {
            validPoint.y = 0.0
        }
        
        return validPoint
    }
    
    // MARK: - Convenience
    
    /// This method helps to hide and show the CornerViews based on the boolen
    ///
    /// - Parameter hidden: boolen to hide or show
    private func cornerViews(hidden: Bool) {
        topLeftCornerView.isHidden = hidden
        topRightCornerView.isHidden = hidden
        bottomRightCornerView.isHidden = hidden
        bottomLeftCornerView.isHidden = hidden
    }
    
    /// This method updates the quadrilateral with the positions and the corners and returns the rectangle as quadrilateral
    ///
    /// - Parameters:
    ///   - quad: quad position
    ///   - position: position points in `CGPoint`
    ///   - corner: corner of the quadrilateral
    /// - Returns: returns the rectangle as quadrilateral
    private func update(_ quad: Quadrilateral, withPosition position: CGPoint, forCorner corner: CornerPosition) -> Quadrilateral {
        var quad = quad
        
        switch corner {
        case .topLeft:
            quad.topLeft = position
        case .topRight:
            quad.topRight = position
        case .bottomRight:
            quad.bottomRight = position
        case .bottomLeft:
            quad.bottomLeft = position
        }
        
        return quad
    }
    
    /// cornerViewForCornerPosition method is used to check with the position and returns corner for   `EditScanCornerView`
    ///
    /// - Parameter position: cornerView Position
    /// - Returns: returns corner for   `EditScanCornerView`
    func cornerViewForCornerPosition(position: CornerPosition) -> EditScanCornerView {
        switch position {
        case .topLeft:
            return topLeftCornerView
        case .topRight:
            return topRightCornerView
        case .bottomLeft:
            return bottomLeftCornerView
        case .bottomRight:
            return bottomRightCornerView
        }
    }
}

