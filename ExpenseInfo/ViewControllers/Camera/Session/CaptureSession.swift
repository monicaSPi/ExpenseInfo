

import Foundation
import ImageIO
/// A class containing global variables and settings for this capture session
final class CaptureSession {
    
    /// Instance of global variables and settings for this capture session
    static let current = CaptureSession()
    
    /// Whether the user is past the scanning screen or not (needed to disable auto scan on other screens)
    var isEditing: Bool
    
    /// Whether auto scan is enabled or not
    var autoScanEnabled: Bool
    
    /// The orientation of the captured image
    var editImageOrientation: CGImagePropertyOrientation
    
    /// Initializing the capture session
    ///
    /// - Parameters:
    ///   - autoScanEnabled: autoScanEnabled true
    ///   - editImageOrientation: editImageOrientation up
    private init(autoScanEnabled: Bool = true, editImageOrientation: CGImagePropertyOrientation = .up) {
        self.isEditing = false
        self.autoScanEnabled = autoScanEnabled
        self.editImageOrientation = editImageOrientation
    }
    
}
