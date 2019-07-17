

import Foundation
import ImageIO
/// A class containing global variables and settings for this capture session
final class CaptureSession {
    
    /// <#Description#>
    static let current = CaptureSession()
    
    /// Whether the user is past the scanning screen or not (needed to disable auto scan on other screens)
    var isEditing: Bool
    
    /// Whether auto scan is enabled or not
    var autoScanEnabled: Bool
    
    /// The orientation of the captured image
    var editImageOrientation: CGImagePropertyOrientation
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - autoScanEnabled: <#autoScanEnabled description#>
    ///   - editImageOrientation: <#editImageOrientation description#>
    private init(autoScanEnabled: Bool = true, editImageOrientation: CGImagePropertyOrientation = .up) {
        self.isEditing = false
        self.autoScanEnabled = autoScanEnabled
        self.editImageOrientation = editImageOrientation
    }
    
}
