

import UIKit
import AVFoundation

/// This will allow the user to edit the scanned image
final class EditScanViewController: UIViewController {
    
    
    // MARK: IBOutlet Properties
    
    ///  retakeBtn that executes your custom code in response to user interactions.
    @IBOutlet weak var retakeBtn: UIButton! {
        didSet {
            retakeBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            retakeBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            retakeBtn.layer.shadowOpacity = 1.0
            retakeBtn.layer.shadowRadius = 10.0
            retakeBtn.layer.masksToBounds = false
        }
    }
    
    /// Designable doneBtn that executes your custom code in response to user interactions.
    @IBOutlet weak var doneBtn: RoundButton! {
        didSet {
            doneBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            doneBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            doneBtn.layer.shadowOpacity = 1.0
            doneBtn.layer.shadowRadius = 10.0
            doneBtn.layer.masksToBounds = false
        }
    }
    
    /// cropBtn that executes your custom code in response to user interactions.
    @IBOutlet weak var cropBtn: UIButton! {
        didSet {
            cropBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            cropBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            cropBtn.layer.shadowOpacity = 1.0
            cropBtn.layer.shadowRadius = 10.0
            cropBtn.layer.masksToBounds = false
        }
    }
    
    /// finalImageView that displays a single image or a sequence of animated images in your interface.
    @IBOutlet weak var finalImageView: UIImageView!
    
    /// centerView that manages the content for a rectangular area on the screen.
    @IBOutlet weak var centerView: UIView!
    
    /// blackImg that displays a single image or a sequence of animated images in your interface.
    @IBOutlet weak var blackImg: UIImageView!
    
    // MARK: - File Private
    
    /// imageView displays a single image or a sequence of animated images in your interface.
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = image
        finalImageView.image = image
        blackImg.image = image
        finalImageView.contentMode = .scaleAspectFit
        blackImg.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// The QuadrilateralView is a simple UIView subclass that can draw a quadrilateral, and optionally edit it.
    lazy private var quadView: QuadrilateralView = {
        let quadView = QuadrilateralView()
        quadView.editable = true
        quadView.translatesAutoresizingMaskIntoConstraints = false
        return quadView
    }()
    
    /// nextButton in toolbar is used to navigate to reviewviewcontroller
    lazy private var nextButton: UIBarButtonItem = {
        let title = NSLocalizedString("wescan.edit.button.next", tableName: nil, bundle: Bundle(for: EditScanViewController.self), value: "Next", comment: "A generic next button")
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(pushReviewController))
        button.tintColor = navigationController?.navigationBar.tintColor
        return button
    }()
    
    
    /// This class is used to zoom the images using the gesture recognization
    private var zoomGestureController: ZoomGestureController!
    
    /// quadViewWidthConstraint that must be satisfied by the constraint-based layout system.
    private var quadViewWidthConstraint = NSLayoutConstraint()
    
    /// quadViewHeightConstraint that must be satisfied by the constraint-based layout system.
    private var quadViewHeightConstraint = NSLayoutConstraint()
    
    // MARK: - Local variable
    
    /// An object that manages image data in your app.
    var image : UIImage?
    
    /// A data structure representing a quadrilateral and its position. This class exists to bypass the fact that CIRectangleFeature is read-only.
    var quad: Quadrilateral?
    
    // MARK: Default View Controller Methods
    /// Called after the controller's view is loaded into memory.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image = image?.applyingPortraitOrientation()
        self.quad = quad ?? EditScanViewController.defaultQuad(forImage: image!)
        setupViews()
        
        setupConstraints()
        title = NSLocalizedString("wescan.edit.title", tableName: nil, bundle: Bundle(for: EditScanViewController.self), value: "Edit Scan", comment: "The title of the EditScanViewController")
        navigationItem.rightBarButtonItem = nextButton
        
        zoomGestureController = ZoomGestureController(image: image!, quadView: quadView)
        
        let touchDown = UILongPressGestureRecognizer(target: zoomGestureController, action: #selector(zoomGestureController.handle(pan:)))
        touchDown.minimumPressDuration = 0
        centerView.addGestureRecognizer(touchDown)
    }
    /// Called to notify the view controller that its view has just laid out its subviews.
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustQuadViewConstraints()
        displayQuad()
    }
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    ///
    /// - Parameter animated: If true, the view is being added to the window using an animation.
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    ///
    /// - Parameter animated: If true, the disappearance of the view is being animated.
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    
    // MARK: IBAction Methods
    
    /// This method is used to finalize the image after proper edit and scan and send the image to mainviewcontroller
    ///
    /// - Parameter sender: sender id
    @IBAction func doneAction(_ sender: UIButton) {
        
        
        
        let Obj: UIViewController = UIStoryboard(name: AppConstants.XIB.Names.MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.MainViewController)
        
        let imageData: Data? = blackImg.image!.pngData()
        let objNav = UINavigationController(rootViewController: Obj)
        
        UserDefaults.standard.setValue(imageData, forKey: AppConstants.Defaults.Key.DisplayImg)
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.set(imageData, forKey: AppConstants.Defaults.Key.ReceiptImg)
        
        UserDefaults.standard.synchronize()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        present(objNav, animated: true)
        
    }
    
    /// This method is used to dismiss the EditScanViewController from the navigation stack
    ///
    /// - Parameter sender: sender id
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// This method helps to retake the image
    ///
    /// - Parameter sender: sender id
    @IBAction func reTakeAction(_ sender: UIButton) {
        cropBtn.isEnabled = true
        self.finalImageView.isHidden = true
        self.imageView.isHidden = false
        self.quadView.isHidden = false
        self.view.sendSubviewToBack(finalImageView)
    }
    
    /// This method is called when crop operation is done and ready to send to review
    ///
    /// - Parameter sender: sender id
    @IBAction func cropAction(_ sender: UIButton) {
        pushReviewController()
    }
    
    // MARK: - Custom Action
    
    /// Setup subviews to the parentView
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(quadView)
        view.bringSubviewToFront(centerView)
    }
    
    /// This method is to setup the constraints for the views
    private func setupConstraints() {
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: centerView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: centerView.trailingAnchor),
            centerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            centerView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ]
        
        quadViewWidthConstraint = quadView.widthAnchor.constraint(equalToConstant: 0.0)
        quadViewHeightConstraint = quadView.heightAnchor.constraint(equalToConstant: 0.0)
        
        let quadViewConstraints = [
            quadView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            quadView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            quadViewWidthConstraint,
            quadViewHeightConstraint
        ]
        
        NSLayoutConstraint.activate(quadViewConstraints + imageViewConstraints)
    }
    
    
    /// This method take the view from edit view to review the edited image to final review
    @objc func pushReviewController() {
        guard let quad = quadView.quad,
            let ciImage = CIImage(image: image!) else {
                if let imageScannerController = navigationController as? ImageScannerController {
                    let error = ImageScannerControllerError.ciImageCreation
                    imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFailWithError: error)
                }
                return
        }
        
        let scaledQuad = quad.scale(quadView.bounds.size, (image?.size)!)
        self.quad = scaledQuad
        
        var cartesianScaledQuad = scaledQuad.toCartesian(withHeight: (image?.size.height)!)
        cartesianScaledQuad.reorganize()
        
        let filteredImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
            ])
        
        let enhancedImage = filteredImage.applyingAdaptiveThreshold()?.withFixedOrientation()
        
        var uiImage: UIImage!
        
        if let cgImage = CIContext(options: nil).createCGImage(filteredImage, from: filteredImage.extent) {
            uiImage = UIImage(cgImage: cgImage)
        } else {
            uiImage = UIImage(ciImage: filteredImage, scale: 1.0, orientation: .up)
        }
        
        
        let finalImage = uiImage.withFixedOrientation()
        
        
        if let result:ImageScannerResults = ImageScannerResults(originalImage: image!, scannedImage: finalImage, enhancedImage: enhancedImage!, doesUserPreferEnhancedImage: false, detectedRectangle: scaledQuad) {
            finalImageView.image = result.scannedImage
            finalImageView.isHidden = false
            var _: Data? = finalImageView.image!.pngData()
            blackImg.image = result.enhancedImage
            cropBtn.isEnabled = false
            self.imageView.isHidden = true
            self.quadView.isHidden = true
            self.view.bringSubviewToFront(finalImageView)
            
        }
    }
    
    /// This method is used to find the document path with filename
    ///
    /// - Parameter name: filename
    /// - Returns: document path url
    func documentsPath(forFileName name: String?) -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsPath = paths[0]
        
        return URL(fileURLWithPath: documentsPath).appendingPathComponent(name!).absoluteString
    }
    
    
    /// This method is to display the Quadrilateral to QuadView
    private func displayQuad() {
        let imageSize = image?.size
        let imageFrame = CGRect(origin: imageView.frame.origin, size: CGSize(width: quadViewWidthConstraint.constant, height: quadViewHeightConstraint.constant))
        
        let scaleTransform = CGAffineTransform.scaleTransform(forSize: imageSize!, aspectFillInSize: imageFrame.size)
        let transforms = [scaleTransform]
        let transformedQuad = quad?.applyTransforms(transforms)
        
        quadView.drawQuadrilateral(quad: transformedQuad!, animated: false)
    }
    
    /// This method is used to adjust the Quad View Constraint constant
    private func adjustQuadViewConstraints() {
        let frame = AVMakeRect(aspectRatio: (image?.size)!, insideRect: imageView.bounds)
        quadViewWidthConstraint.constant = frame.size.width
        quadViewHeightConstraint.constant = frame.size.height
    }
    
    /// This method sets the default values for the QuadCorners
    ///
    /// - Parameter image: Quad image
    /// - Returns: return Quadrilateral
    private static func defaultQuad(forImage image: UIImage) -> Quadrilateral {
        let topLeft = CGPoint(x: image.size.width / 3.0, y: image.size.height / 3.0)
        let topRight = CGPoint(x: 2.0 * image.size.width / 3.0, y: image.size.height / 3.0)
        let bottomRight = CGPoint(x: 2.0 * image.size.width / 3.0, y: 2.0 * image.size.height / 3.0)
        let bottomLeft = CGPoint(x: image.size.width / 3.0, y: 2.0 * image.size.height / 3.0)
        
        let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        
        return quad
    }
    
}
