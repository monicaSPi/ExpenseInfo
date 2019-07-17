


import Foundation

/// Errors related to the `ImageScannerController`
public enum ImageScannerControllerError: Error {
    /// The user didn't grant permission to use the camera.
    case authorization
    /// An error occured when setting up the user's device.
    case inputDevice
    /// An error occured when trying to capture a picture.
    case capture
    /// Error when creating the CIImage.
    case ciImageCreation
}

