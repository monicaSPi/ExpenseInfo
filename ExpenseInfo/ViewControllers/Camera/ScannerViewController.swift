

import UIKit
import AVFoundation

/// <#Description#>
///
/// - successful: <#successful description#>
/// - notSuccessful: <#notSuccessful description#>
enum FlashResult {
    case successful
    case notSuccessful
}

/// <#Description#>
final class ScannerViewController: UIViewController {
    
    /// <#Description#>
    private var captureSessionManager: CaptureSessionManager?
    
    /// <#Description#>
    private let videoPreviewlayer = AVCaptureVideoPreviewLayer()
    
    /// <#Description#>
    private let quadView = QuadrilateralView()
    
    /// <#Description#>
    private var flashEnabled = false
    
    /// <#Description#>
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// <#Description#>
    lazy private var shutterButton: ShutterButton = {
        let button = ShutterButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
        return button
    }()
    
    /// <#Description#>
    lazy private var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "closeButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    
    
    /// <#Description#>
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    /// Called after the controller's view is loaded into memory.

    override func viewDidLoad() {
        super.viewDidLoad()
        CaptureSession.current.autoScanEnabled = false
        title = NSLocalizedString("wescan.scanning.title", tableName: nil, bundle: Bundle(for: ScannerViewController.self), value: "Scanning", comment: "The title of the ScannerViewController")
        
        setupViews()
        setupConstraints()
        
        captureSessionManager = CaptureSessionManager(videoPreviewLayer: videoPreviewlayer)
        captureSessionManager?.delegate = self
    }
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    ///
    /// - Parameter animated: If true, the view is being added to the window using an animation.

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CaptureSession.current.isEditing = false
        quadView.removeQuadrilateral()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            checkCameraAccess(isAllowed: {
                if $0 {
                    DispatchQueue.main.async {
                       // self.presentCamera()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presentCameraSettings()
                    }
                }
            })
        }
        
        
        
        captureSessionManager?.start()
        UIApplication.shared.isIdleTimerDisabled = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
  
    /// <#Description#>
    private func presentCameraSettings() {
        DispatchQueue.main.async {
            let changePrivacySetting = "Expense doesn't have permission to use the camera, please change privacy settings"
            let message = NSLocalizedString(changePrivacySetting, comment: "camera")
            let alertController = UIAlertController(title: "Expense", message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                    style: .cancel,
                                                    handler: nil))
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"),
                                                    style: .`default`,
                                                    handler: { _ in
                                                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                                                  options: [:],
                                                                                  completionHandler: nil)
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter isAllowed: <#isAllowed description#>
    func checkCameraAccess(isAllowed: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            isAllowed(false)
        case .restricted:
            isAllowed(false)
        case .authorized:
            isAllowed(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isAllowed($0) }
        @unknown default:
            break
        }
    }
    /// Called to notify the view controller that its view has just laid out its subviews.

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoPreviewlayer.frame = view.layer.bounds
    }
    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    ///
    /// - Parameter animated: If true, the disappearance of the view is being animated.

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
        //
    }
    
    
    /// <#Description#>
    private func setupViews() {
        view.layer.addSublayer(videoPreviewlayer)
        quadView.translatesAutoresizingMaskIntoConstraints = false
        quadView.editable = false
        view.addSubview(quadView)
        
        view.addSubview(cancelButton)
        view.addSubview(shutterButton)
        view.addSubview(activityIndicator)
    }
    
    /// <#Description#>
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// <#Description#>
    private func setupConstraints() {
        var quadViewConstraints = [NSLayoutConstraint]()
        var cancelButtonConstraints = [NSLayoutConstraint]()
        var shutterButtonConstraints = [NSLayoutConstraint]()
        var activityIndicatorConstraints = [NSLayoutConstraint]()
        
        quadViewConstraints = [
            quadView.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: quadView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: quadView.trailingAnchor),
            quadView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ]
        
        shutterButtonConstraints = [
            shutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shutterButton.widthAnchor.constraint(equalToConstant: 65.0),
            shutterButton.heightAnchor.constraint(equalToConstant: 65.0)
        ]
        
        activityIndicatorConstraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        if #available(iOS 11.0, *) {
//            let window = UIApplication.shared.keyWindow
            
            
            cancelButtonConstraints = [
                cancelButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0),
                view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10.0)
            ]
            
            let shutterButtonBottomConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: shutterButton.bottomAnchor, constant: 8.0)
            shutterButtonConstraints.append(shutterButtonBottomConstraint)
        } else {
            
            cancelButtonConstraints = [
                cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0),
                view.topAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10.0)
            ]
            
            let shutterButtonBottomConstraint = view.bottomAnchor.constraint(equalTo: shutterButton.bottomAnchor, constant: 8.0)
            shutterButtonConstraints.append(shutterButtonBottomConstraint)
        }
        
        NSLayoutConstraint.activate(quadViewConstraints + cancelButtonConstraints + shutterButtonConstraints + activityIndicatorConstraints /*+ toolbarConstraints*/)
    }
    
    // MARK: - Actions
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @objc private func captureImage(_ sender: UIButton) {
        shutterButton.isUserInteractionEnabled = false
        captureSessionManager?.capturePhoto()
    }
    
    /// <#Description#>
    @objc private func toggleAutoScan() {
    }
    
    /// <#Description#>
    @objc private func toggleFlash() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// <#Description#>
    @IBOutlet weak var closeBtn: UIButton!
    
}

// MARK: - UINavigationControllerDelegate
extension ScannerViewController: UINavigationControllerDelegate {
    
}
// MARK: - UIImagePickerControllerDelegate
extension ScannerViewController: UIImagePickerControllerDelegate {
    
}
// MARK: - RectangleDetectionDelegateProtocol
extension ScannerViewController: RectangleDetectionDelegateProtocol {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - captureSessionManager: <#captureSessionManager description#>
    ///   - error: <#error description#>
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didFailWithError error: Error) {
        
        activityIndicator.stopAnimating()
        shutterButton.isUserInteractionEnabled = true
        
        guard let imageScannerController = navigationController as? ImageScannerController else { return }
        imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFailWithError: error)
    }
    
    /// <#Description#>
    ///
    /// - Parameter captureSessionManager: <#captureSessionManager description#>
    func didStartCapturingPicture(for captureSessionManager: CaptureSessionManager) {
        activityIndicator.startAnimating()
        shutterButton.isUserInteractionEnabled = false
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - captureSessionManager: <#captureSessionManager description#>
    ///   - picture: <#picture description#>
    ///   - quad: <#quad description#>
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didCapturePicture picture: UIImage, withQuad quad: Quadrilateral?) {
        activityIndicator.stopAnimating()
        
        let crop = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.EditScanViewController) as? EditScanViewController
        crop?.image = picture//UIImage(data: imageData!)
        crop?.quad = quad
        if let aCrop = crop {
            self.present(aCrop, animated: true)
        }
        shutterButton.isUserInteractionEnabled = true
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - captureSessionManager: <#captureSessionManager description#>
    ///   - quad: <#quad description#>
    ///   - imageSize: <#imageSize description#>
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didDetectQuad quad: Quadrilateral?, _ imageSize: CGSize) {
        guard let quad = quad else {
            quadView.removeQuadrilateral()
            return
        }
        
        let portraitImageSize = CGSize(width: imageSize.height, height: imageSize.width)
        
        let scaleTransform = CGAffineTransform.scaleTransform(forSize: portraitImageSize, aspectFillInSize: quadView.bounds.size)
        let scaledImageSize = imageSize.applying(scaleTransform)
        
        let rotationTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2.0))
        
        let imageBounds = CGRect(origin: .zero, size: scaledImageSize).applying(rotationTransform)
        
        let translationTransform = CGAffineTransform.translateTransform(fromCenterOfRect: imageBounds, toCenterOfRect: quadView.bounds)
        
        let transforms = [scaleTransform, rotationTransform, translationTransform]
        
        let transformedQuad = quad.applyTransforms(transforms)
        
        quadView.drawQuadrilateral(quad: transformedQuad, animated: true)
    }
    
}
