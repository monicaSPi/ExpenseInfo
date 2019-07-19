

import Foundation
import AVFoundation
import UIKit

/// This class is used to zoom the images using the gesture
final class ZoomGestureController {
    
    // MARK: - File Private
    
    /// image
    private let image: UIImage
    
    /// quadView is a simple UIView subclass that can draw a quadrilateral, and optionally edit it.
    private let quadView: QuadrilateralView
    
    ///previousPanPosition contains a point in a two-dimensional coordinate system.
    private var previousPanPosition: CGPoint?
    
    /// closestCorner keep track of the position of the corners of a quadrilateral.
    private var closestCorner: CornerPosition?
    
    // MARK:- Initialization
    
    /// Initializing `ZoomGestureController`
    ///
    /// - Parameters:
    ///   - image: image zoomable
    ///   - quadView: It is a simple UIView subclass that can draw a quadrilateral, and optionally edit it.
    init(image: UIImage, quadView: QuadrilateralView) {
        self.image = image
        self.quadView = quadView
    }
    
    
    // MARK: - UIGestureRecognizer Delegate
    
    /// Handle pan gesture to move the position of quad corners
    ///
    /// - Parameter pan: pan gesture
    @objc func handle(pan: UIGestureRecognizer) {
        guard let drawnQuad = quadView.quad else {
            return
        }
        
        guard pan.state != .ended else {
            self.previousPanPosition = nil
            self.closestCorner = nil
            quadView.resetHighlightedCornerViews()
            return
        }
        
        let position = pan.location(in: quadView)
        
        let previousPanPosition = self.previousPanPosition ?? position
        let closestCorner = self.closestCorner ?? position.closestCornerFrom(quad: drawnQuad)
        
        let offset = CGAffineTransform(translationX: position.x - previousPanPosition.x, y: position.y - previousPanPosition.y)
        let cornerView = quadView.cornerViewForCornerPosition(position: closestCorner)
        let draggedCornerViewCenter = cornerView.center.applying(offset)
        
        quadView.moveCorner(cornerView: cornerView, atPoint: draggedCornerViewCenter)
        
        self.previousPanPosition = position
        self.closestCorner = closestCorner
        
        let scale = image.size.width / quadView.bounds.size.width
        let scaledDraggedCornerViewCenter = CGPoint(x: draggedCornerViewCenter.x * scale, y: draggedCornerViewCenter.y * scale)
        guard let zoomedImage = image.scaledImage(atPoint: scaledDraggedCornerViewCenter, scaleFactor: 2.5, targetSize: quadView.bounds.size) else {
            return
        }
        
        quadView.highlightCornerAtPosition(position: closestCorner, with: zoomedImage)
    }
    
}
