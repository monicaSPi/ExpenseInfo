

import Foundation
import AVFoundation
import UIKit

/// <#Description#>
final class ZoomGestureController {
    
    // MARK: - File Private
    
    /// <#Description#>
    private let image: UIImage
    
    /// <#Description#>
    private let quadView: QuadrilateralView
    
    /// <#Description#>
    private var previousPanPosition: CGPoint?
    
    /// <#Description#>
    private var closestCorner: CornerPosition?
    
    // MARK:- Initialization
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - image: <#image description#>
    ///   - quadView: <#quadView description#>
    init(image: UIImage, quadView: QuadrilateralView) {
        self.image = image
        self.quadView = quadView
    }
    
    
    // MARK: - UIGestureRecognizer Delegate
    
    /// <#Description#>
    ///
    /// - Parameter pan: <#pan description#>
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
