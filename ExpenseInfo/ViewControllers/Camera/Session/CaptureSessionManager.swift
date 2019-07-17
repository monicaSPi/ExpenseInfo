

import Foundation
import CoreMotion
import AVFoundation
import CoreImage
import UIKit
/// A set of functions that inform the delegate object of the state of the detection.
protocol RectangleDetectionDelegateProtocol: NSObjectProtocol {
    
    /// Called when the capture of a picture has started.
    ///
    /// - Parameters:
    ///   - captureSessionManager: The `CaptureSessionManager` instance that started capturing a picture.
    func didStartCapturingPicture(for captureSessionManager: CaptureSessionManager)
    
    /// Called when a quadrilateral has been detected.
    /// - Parameters:
    ///   - captureSessionManager: The `CaptureSessionManager` instance that has detected a quadrilateral.
    ///   - quad: The detected quadrilateral in the coordinates of the image.
    ///   - imageSize: The size of the image the quadrilateral has been detected on.
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didDetectQuad quad: Quadrilateral?, _ imageSize: CGSize)
    
    /// Called when a picture with or without a quadrilateral has been captured.
    ///
    /// - Parameters:
    ///   - captureSessionManager: The `CaptureSessionManager` instance that has captured a picture.
    ///   - picture: The picture that has been captured.
    ///   - quad: The quadrilateral that was detected in the picture's coordinates if any.
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didCapturePicture picture: UIImage, withQuad quad: Quadrilateral?)
    
    /// Called when an error occured with the capture session manager.
    /// - Parameters:
    ///   - captureSessionManager: The `CaptureSessionManager` that encountered an error.
    ///   - error: The encountered error.
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didFailWithError error: Error)
}

/// The CaptureSessionManager is responsible for setting up and managing the AVCaptureSession and the functions related to capturing.
final class CaptureSessionManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    /// <#Description#>
    private let videoPreviewLayer: AVCaptureVideoPreviewLayer
    
    /// <#Description#>
    private let captureSession = AVCaptureSession()
    
    /// <#Description#>
    private let rectangleFunnel = RectangleFeaturesFunnel()
    
    /// <#Description#>
    weak var delegate: RectangleDetectionDelegateProtocol?
    
    /// <#Description#>
    private var displayedRectangleResult: RectangleDetectorResult?
    
    /// <#Description#>
    private var photoOutput = AVCapturePhotoOutput()
    
    /// Whether the CaptureSessionManager should be detecting quadrilaterals.
    private var isDetecting = true
    
    /// The number of times no rectangles have been found in a row.
    private var noRectangleCount = 0
    
    /// The minimum number of time required by `noRectangleCount` to validate that no rectangles have been found.
    private let noRectangleThreshold = 3
    
    // MARK: Life Cycle
    
    /// <#Description#>
    ///
    /// - Parameter videoPreviewLayer: <#videoPreviewLayer description#>
    init?(videoPreviewLayer: AVCaptureVideoPreviewLayer) {
        self.videoPreviewLayer = videoPreviewLayer
        super.init()
        
        guard AVCaptureDevice.default(for: .video) != nil else {
            let error = ImageScannerControllerError.inputDevice
            delegate?.captureSessionManager(self, didFailWithError: error)
            return nil
        }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        photoOutput.isHighResolutionCaptureEnabled = true
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        defer {
            captureSession.commitConfiguration()
        }
        
        guard let inputDevice = AVCaptureDevice.default(for: AVMediaType.video),
            let deviceInput = try? AVCaptureDeviceInput(device: inputDevice),
            captureSession.canAddInput(deviceInput),
            captureSession.canAddOutput(photoOutput),
            captureSession.canAddOutput(videoOutput) else {
                let error = ImageScannerControllerError.inputDevice
                delegate?.captureSessionManager(self, didFailWithError: error)
                return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(photoOutput)
        captureSession.addOutput(videoOutput)
        
        videoPreviewLayer.session = captureSession
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video_ouput_queue"))
    }
    
    // MARK: Capture Session Life Cycle
    
    /// Starts the camera and detecting quadrilaterals.
    internal func start() {

        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch authorizationStatus {
        case .authorized:
            DispatchQueue.main.async {
                self.captureSession.startRunning()
            }
            isDetecting = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (_) in
                DispatchQueue.main.async { [weak self] in
                    self?.start()
                }
            })
        case .denied: // The user has previously denied access.
            return
        case .restricted: // The user can't grant access due to restrictions.
            return
        default:
            let error = ImageScannerControllerError.authorization
            delegate?.captureSessionManager(self, didFailWithError: error)
        }
    }
    
    /// <#Description#>
    internal func stop() {
        captureSession.stopRunning()
    }
    
    /// <#Description#>
    internal func capturePhoto() {
        
        let captureConnection = photoOutput.connections.first { (connection) -> Bool in
            return connection.inputPorts.first(where: { (port) -> Bool in
                port.mediaType == .video
            }) != nil
        }
        guard let connection = captureConnection, connection.isEnabled, connection.isActive else {
            let error = ImageScannerControllerError.capture
            delegate?.captureSessionManager(self, didFailWithError: error)
            return
        }
        
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.isAutoStillImageStabilizationEnabled = true
        
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - output: <#output description#>
    ///   - sampleBuffer: <#sampleBuffer description#>
    ///   - connection: <#connection description#>
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard isDetecting == true else {
            return
        }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let finalImage = CIImage(cvPixelBuffer: pixelBuffer)
        let imageSize = finalImage.extent.size
        
        if #available(iOS 11.0, *) {
            VisionRectangleDetector.rectangle(forImage: finalImage) { (rectangle) in
                self.processRectangle(rectangle: rectangle, imageSize: imageSize)
            }
        } else {
            CIRectangleDetector.rectangle(forImage: finalImage) { (rectangle) in
                self.processRectangle(rectangle: rectangle, imageSize: imageSize)
            }
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - rectangle: <#rectangle description#>
    ///   - imageSize: <#imageSize description#>
    private func processRectangle(rectangle: Quadrilateral?, imageSize: CGSize) {
        if let rectangle = rectangle {
            
            self.noRectangleCount = 0
            self.rectangleFunnel.add(rectangle, currentlyDisplayedRectangle: self.displayedRectangleResult?.rectangle) { [weak self] (result, rectangle) in
                
                guard let strongSelf = self else {
                    return
                }
                
                let shouldAutoScan = (result == .showAndAutoScan)
                strongSelf.displayRectangleResult(rectangleResult: RectangleDetectorResult(rectangle: rectangle, imageSize: imageSize))
                if shouldAutoScan, CaptureSession.current.autoScanEnabled, !CaptureSession.current.isEditing {
                    capturePhoto()
                }
            }
            
        } else {
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.noRectangleCount += 1
                
                if strongSelf.noRectangleCount > strongSelf.noRectangleThreshold {
                    // Reset the currentAutoScanPassCount, so the threshold is restarted the next time a rectangle is found
                    strongSelf.rectangleFunnel.currentAutoScanPassCount = 0
                    
                    // Remove the currently displayed rectangle as no rectangles are being found anymore
                    strongSelf.displayedRectangleResult = nil
                    strongSelf.delegate?.captureSessionManager(strongSelf, didDetectQuad: nil, imageSize)
                }
            }
            return
            
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter rectangleResult: <#rectangleResult description#>
    /// - Returns: <#return value description#>
    @discardableResult private func displayRectangleResult(rectangleResult: RectangleDetectorResult) -> Quadrilateral {
        displayedRectangleResult = rectangleResult
        
        let quad = rectangleResult.rectangle.toCartesian(withHeight: rectangleResult.imageSize.height)
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.delegate?.captureSessionManager(strongSelf, didDetectQuad: quad, rectangleResult.imageSize)
        }
        
        return quad
    }
    
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CaptureSessionManager: AVCapturePhotoCaptureDelegate {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - captureOutput: <#captureOutput description#>
    ///   - photoSampleBuffer: <#photoSampleBuffer description#>
    ///   - previewPhotoSampleBuffer: <#previewPhotoSampleBuffer description#>
    ///   - resolvedSettings: <#resolvedSettings description#>
    ///   - bracketSettings: <#bracketSettings description#>
    ///   - error: <#error description#>
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            delegate?.captureSessionManager(self, didFailWithError: error)
            return
        }
        
        CaptureSession.current.setImageOrientation()
        
        isDetecting = false
        rectangleFunnel.currentAutoScanPassCount = 0
        delegate?.didStartCapturingPicture(for: self)
//        @available(iOS 11.0, *)
//        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//            let imageData = photo.fileDataRepresentation()
//        }
        if let sampleBuffer = photoSampleBuffer,
            let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: nil) {
            completeImageCapture(with: imageData)
        } else {
            let error = ImageScannerControllerError.capture
            delegate?.captureSessionManager(self, didFailWithError: error)
            return
        }
        
    }
    
    @available(iOS 11.0, *)
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - output: <#output description#>
    ///   - photo: <#photo description#>
    ///   - error: <#error description#>
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            delegate?.captureSessionManager(self, didFailWithError: error)
            return
        }
        
        CaptureSession.current.setImageOrientation()
        
        isDetecting = false
        rectangleFunnel.currentAutoScanPassCount = 0
        delegate?.didStartCapturingPicture(for: self)
        
        if let imageData = photo.fileDataRepresentation() {
            completeImageCapture(with: imageData)
        } else {
            let error = ImageScannerControllerError.capture
            delegate?.captureSessionManager(self, didFailWithError: error)
            return
        }
    }
    
    /// Completes the image capture by processing the image, and passing it to the delegate object.
    /// This function is necessary because the capture functions for iOS 10 and 11 are decoupled.
    
    /// <#Description#>
    ///
    /// - Parameter imageData: <#imageData description#>
    private func completeImageCapture(with imageData: Data) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            CaptureSession.current.isEditing = true
            guard let image = UIImage(data: imageData) else {
                let error = ImageScannerControllerError.capture
                DispatchQueue.main.async {
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.delegate?.captureSessionManager(strongSelf, didFailWithError: error)
                }
                return
            }
            
            var angle: CGFloat = 0.0
            
            switch image.imageOrientation {
            case .right:
                angle = CGFloat.pi / 2
            case .up:
                angle = CGFloat.pi
            default:
                break
            }
            
            var quad: Quadrilateral?
            if let displayedRectangleResult = self?.displayedRectangleResult {
                quad = self?.displayRectangleResult(rectangleResult: displayedRectangleResult)
                quad = quad?.scale(displayedRectangleResult.imageSize, image.size, withRotationAngle: angle)
            }
            
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.captureSessionManager(strongSelf, didCapturePicture: image, withQuad: quad)
            }
        }
    }
    
    
}

/// Data structure representing the result of the detection of a quadrilateral.
private struct RectangleDetectorResult {
    
    /// The detected quadrilateral.
    let rectangle: Quadrilateral
    
    /// The size of the image the quadrilateral was detected on.
    let imageSize: CGSize
    
}