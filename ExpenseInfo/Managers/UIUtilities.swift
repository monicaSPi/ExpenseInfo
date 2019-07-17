

import AVFoundation
import UIKit

import FirebaseMLVision


/// Defines UI-related utilitiy methods for vision detection.
public class UIUtilities {


  /// Adding Rectangle to the specific view with particular color
  ///
  /// - Parameters:
  ///   - rectangle: `CGRect` points for the view
  ///   - view: view where the rectangleView frame has
  ///   - color: rectangle line color
  public static func addRectangle(_ rectangle: CGRect, to view: UIView, color: UIColor) {
    let rectangleView = UIView(frame: rectangle)
    rectangleView.layer.cornerRadius = Constants.rectangleViewCornerRadius
    rectangleView.alpha = Constants.rectangleViewAlpha
    rectangleView.backgroundColor = color
    view.addSubview(rectangleView)
  }


}

// MARK: - Constants

/// Private enumerator for drawing a rectangle
private enum Constants {
  static let circleViewAlpha: CGFloat = 0.7
  static let rectangleViewAlpha: CGFloat = 0.3
  static let shapeViewAlpha: CGFloat = 0.3
  static let rectangleViewCornerRadius: CGFloat = 10.0
}
