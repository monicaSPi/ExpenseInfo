

import Foundation
import CoreGraphics

// MARK: - CGPoint Extension
extension CGPoint {
    
    /// Returns a rectangle of a given size surounding the point.
    ///
    /// - Parameters:
    ///   - size: The size of the rectangle that should surround the points.
    /// - Returns: A `CGRect` instance that surrounds this instance of `CGpoint`.
    func surroundingSquare(withSize size: CGFloat) -> CGRect {
        return CGRect(x: x - size / 2.0, y: y - size / 2.0, width: size, height: size)
    }
    
    /// Checks wether this point is within a given distance of another point.
    ///
    /// - Parameters:
    ///   - delta: The minimum distance to meet for this distance to return true.
    ///   - point: The second point to compare this instance with.
    /// - Returns: True if the given `CGPoint` is within the given distance of this instance of `CGPoint`.
    func isWithin(delta: CGFloat, ofPoint point: CGPoint) -> Bool {
        return (abs(x - point.x) <= delta) && (abs(y - point.y) <= delta)
    }
    
    /// Returns the same `CGPoint` in the cartesian coordinate system.
    ///
    /// - Parameters:
    ///   - height: The height of the bounds this points belong to, in the current coordinate system.
    /// - Returns: The same point in the cartesian coordinate system.
    func cartesian(withHeight height: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: height - y)
    }
    
    
    
    /// This method is used to get the distance between two points
    ///
    /// - Parameter point: point as `CGPoint`
    /// - Returns: Returns the distance between two points in `CGFloat`
    func distanceTo(point: CGPoint) -> CGFloat {
        return hypot((self.x - point.x), (self.y - point.y))
    }
    
    
    
    /// This method is used to get closest corner from the point
    ///
    /// - Parameter quad: quad corners
    /// - Returns: Returns the closest corner from the point
    func closestCornerFrom(quad: Quadrilateral) -> CornerPosition {
        var smallestDistance = distanceTo(point: quad.topLeft)
        var closestCorner = CornerPosition.topLeft
        
        if distanceTo(point: quad.topRight) < smallestDistance {
            smallestDistance = distanceTo(point: quad.topRight)
            closestCorner = .topRight
        }
        
        if distanceTo(point: quad.bottomRight) < smallestDistance {
            smallestDistance = distanceTo(point: quad.bottomRight)
            closestCorner = .bottomRight
        }
        
        if distanceTo(point: quad.bottomLeft) < smallestDistance {
            smallestDistance = distanceTo(point: quad.bottomLeft)
            closestCorner = .bottomLeft
        }
        
        return closestCorner
    }
    
}
