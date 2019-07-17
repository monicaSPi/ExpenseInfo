

import UIKit

/// <#Description#>
private let transformIdentity = CATransform3D(m11: 1, m12: 0, m13: 0, m14: 0,
                                                  m21: 0, m22: 1, m23: 0, m24: 0,
                                                  m31: 0, m32: 0, m33: 1, m34: 0,
                                                  m41: 0, m42: 0, m43: 0, m44: 1)

/// <#Description#>
open class VegaScrollFlowLayout: UICollectionViewFlowLayout {
    
    /// <#Description#>
    open var springHardness: CGFloat = 15
    
    /// <#Description#>
    open var isPagingEnabled: Bool = true
    
    /// <#Description#>
    private var dynamicAnimator: UIDynamicAnimator!
    
    /// <#Description#>
    private var visibleIndexPaths = Set<IndexPath>()
    
    /// <#Description#>
    private var latestDelta: CGFloat = 0
    
    // MARK: - Initialization
    
    /// Initialize
    override public init() {
        super.init()
        initialize()
    }
    /// Returns an object initialized from data in a given unarchiver.
    ///
    /// - Parameter aDecoder: An unarchiver object.

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    /// Initializing dynamic animator to the layout
    private func initialize() {
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    // MARK: - Public
    
    /// Resetting the layout by removing dynamic animator
    open func resetLayout() {
        dynamicAnimator.removeAllBehaviors()
        prepare()
    }
    
    // MARK: - Overrides
    
    /// Tells the layout object to update the current layout.
    override open func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
		
		// expand the visible rect slightly to avoid flickering when scrolling quickly
		let expandBy: CGFloat = -100
        let visibleRect = CGRect(origin: collectionView.bounds.origin,
                                 size: collectionView.frame.size).insetBy(dx: 0, dy: expandBy)
        
        guard let visibleItems = super.layoutAttributesForElements(in: visibleRect) else { return }
        let indexPathsInVisibleRect = Set(visibleItems.map{ $0.indexPath })
        
        removeNoLongerVisibleBehaviors(indexPathsInVisibleRect: indexPathsInVisibleRect)
        
        let newlyVisibleItems = visibleItems.filter { item in
            return !visibleIndexPaths.contains(item.indexPath)
        }
        
        addBehaviors(for: newlyVisibleItems)
    }
    
    /// Returns the point at which to stop scrolling.
    ///
    /// - Parameters:
    ///   - proposedContentOffset: The proposed point (in the collection view’s content view) at which to stop scrolling. This is the value at which scrolling would naturally stop if no adjustments were made. The point reflects the upper-left corner of the visible content.
    ///   - velocity: The current scrolling velocity along both the horizontal and vertical axes. This value is measured in points per second.
    /// - Returns: The content offset that you want to use instead. This value reflects the adjusted upper-left corner of the visible area. The default implementation of this method returns the value in the proposedContentOffset parameter.
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                           withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        guard isPagingEnabled else {
            return latestOffset
        }
		
        let row = ((proposedContentOffset.y) / (itemSize.height + minimumLineSpacing)).rounded()
        
        let calculatedOffset = row * itemSize.height + row * minimumLineSpacing
        let targetOffset = CGPoint(x: latestOffset.x, y: calculatedOffset)
        return targetOffset
    }
    
    /// Returns the layout attributes for all of the cells and views in the specified rectangle.
    ///
    /// - Parameter rect: The rectangle (specified in the collection view’s coordinate system) containing the target views.
    /// - Returns: An array of UICollectionViewLayoutAttributes objects representing the layout information for the cells and views. The default implementation returns nil.
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let dynamicItems = dynamicAnimator.items(in: rect) as? [UICollectionViewLayoutAttributes]
        dynamicItems?.forEach { item in
			let convertedY = item.center.y - collectionView.contentOffset.y	- sectionInset.top
			item.zIndex = item.indexPath.row
			transformItemIfNeeded(y: convertedY, item: item)
        }
        return dynamicItems
    }
	
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - y: <#y description#>
    ///   - item: <#item description#>
	private func transformItemIfNeeded(y: CGFloat, item: UICollectionViewLayoutAttributes) {
		guard itemSize.height > 0, y < itemSize.height * 0.5 else {
			return
		}
		
		let scaleFactor: CGFloat = scaleDistributor(x: y)
		
		let yDelta = getYDelta(y: y)
		
		item.transform3D = CATransform3DTranslate(transformIdentity, 0, yDelta, 0)
		item.transform3D = CATransform3DScale(item.transform3D, scaleFactor, scaleFactor, scaleFactor)
		item.alpha = alphaDistributor(x: y)
	
	}
	
    /// Returns the layout attributes for the item at the specified index path.
    ///
    /// - Parameter indexPath: The index path of the item.
    /// - Returns: A layout attributes object containing the information to apply to the item’s cell.
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return dynamicAnimator.layoutAttributesForCell(at: indexPath)!
    }
    
    /// Asks the layout object if the new bounds require a layout update.
    ///
    /// - Parameter newBounds: The new bounds of the collection view.
    /// - Returns: true if the collection view requires a layout update or false if the layout does not need to change.

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let scrollView = self.collectionView!
        let delta = newBounds.origin.y - scrollView.bounds.origin.y
        latestDelta = delta
        
        let touchLocation = collectionView!.panGestureRecognizer.location(in: collectionView)
        
        dynamicAnimator.behaviors.compactMap { $0 as? UIAttachmentBehavior }.forEach { behavior in
            let attrs = behavior.items.first as! UICollectionViewLayoutAttributes
            attrs.center = getUpdatedBehaviorItemCenter(behavior: behavior, touchLocation: touchLocation)
            self.dynamicAnimator.updateItem(usingCurrentState: attrs)
        }
        return false
    }
    
    // MARK: - Utils
    
    /// <#Description#>
    ///
    /// - Parameter indexPaths: <#indexPaths description#>
    private func removeNoLongerVisibleBehaviors(indexPathsInVisibleRect indexPaths: Set<IndexPath>) {
        //get no longer visible behaviors
        let noLongerVisibleBehaviours = dynamicAnimator.behaviors.filter { behavior in
            guard let behavior = behavior as? UIAttachmentBehavior,
                let item = behavior.items.first as? UICollectionViewLayoutAttributes else { return false }
            return !indexPaths.contains(item.indexPath)
        }
        
        //remove no longer visible behaviors
        noLongerVisibleBehaviours.forEach { behavior in
            guard let behavior = behavior as? UIAttachmentBehavior,
                let item = behavior.items.first as? UICollectionViewLayoutAttributes else { return }
            self.dynamicAnimator.removeBehavior(behavior)
            self.visibleIndexPaths.remove(item.indexPath)
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter items: <#items description#>
    private func addBehaviors(for items: [UICollectionViewLayoutAttributes]) {
        guard let collectionView = collectionView else { return }
        let touchLocation = collectionView.panGestureRecognizer.location(in: collectionView)
        
        items.forEach { item in
            let springBehaviour = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
            
            springBehaviour.length = 0.0
            springBehaviour.damping = 0.8
            springBehaviour.frequency = 1.0
            
            if !CGPoint.zero.equalTo(touchLocation) {
                item.center = getUpdatedBehaviorItemCenter(behavior: springBehaviour, touchLocation: touchLocation)
            }
            
            self.dynamicAnimator.addBehavior(springBehaviour)
            self.visibleIndexPaths.insert(item.indexPath)
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - behavior: <#behavior description#>
    ///   - touchLocation: <#touchLocation description#>
    /// - Returns: <#return value description#>
    private func getUpdatedBehaviorItemCenter(behavior: UIAttachmentBehavior,
                                              touchLocation: CGPoint) -> CGPoint {
        let yDistanceFromTouch = abs(touchLocation.y - behavior.anchorPoint.y)
        let xDistanceFromTouch = abs(touchLocation.x - behavior.anchorPoint.x)
        let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / (springHardness * 100)
        
        let attrs = behavior.items.first as! UICollectionViewLayoutAttributes
        var center = attrs.center
        if latestDelta < 0 {
            center.y += max(latestDelta, latestDelta * scrollResistance)
        } else {
            center.y += min(latestDelta, latestDelta * scrollResistance)
        }
        return center
    }
    
    // MARK: - Distribution functions
    
    /**
     Distribution function that start as a square root function and levels off when reaches y = 1.
     - parameter x: X parameter of the function. Current layout implementation uses center.y coordinate of collectionView cells.
     - parameter threshold: The x coordinate where function gets value 1.
     - parameter xOrigin: x coordinate of the function origin.
     */
    
    private func distributor(x: CGFloat, threshold: CGFloat, xOrigin: CGFloat) -> CGFloat {
		guard threshold > xOrigin else {
			return 1
		}
        var arg = (x - xOrigin)/(threshold - xOrigin)
        arg = arg <= 0 ? 0 : arg
        let y = sqrt(arg)
        return y > 1 ? 1 : y
    }
	
    /// <#Description#>
    ///
    /// - Parameter x: <#x description#>
    /// - Returns: <#return value description#>
	private func scaleDistributor(x: CGFloat) -> CGFloat {
		return distributor(x: x, threshold: itemSize.height * 0.5, xOrigin: -itemSize.height * 5)
    }
    
    /// <#Description#>
    ///
    /// - Parameter x: <#x description#>
    /// - Returns: <#return value description#>
    private func alphaDistributor(x: CGFloat) -> CGFloat {
		return distributor(x: x, threshold: itemSize.height * 0.5, xOrigin: -itemSize.height)
    }
	
    /// <#Description#>
    ///
    /// - Parameter y: <#y description#>
    /// - Returns: <#return value description#>
	private func getYDelta(y: CGFloat) -> CGFloat {
		return itemSize.height * 0.5 - y
	}
}
