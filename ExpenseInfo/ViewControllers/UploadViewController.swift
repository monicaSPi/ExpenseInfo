

import UIKit
import SafariServices
import Photos
import Foundation

import CoreTelephony
import MobileCoreServices


/// <#Description#>
class UploadViewController: UIViewController {
    
    /// <#Description#>
    @IBOutlet var imageView: UIImageView!
    
    /// <#Description#>
    var imagePicker = UIImagePickerController()
    
    /// <#Description#>
    var viewController: UIViewController?
    
    /// <#Description#>
    var pickImageCallback : ((UIImage) -> ())?;
    
    /// <#Description#>
    private var displayedRectangleResult: RectangleDetectorResult?

    /// <#Description#>
    @IBOutlet weak var uploadBtn: UIButton! {
        didSet {
            uploadBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            uploadBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            uploadBtn.layer.shadowOpacity = 1.0
            uploadBtn.layer.shadowRadius = 10.0
            uploadBtn.layer.masksToBounds = false

        }
    }
    
    /// <#Description#>
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func cloaseAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /// <#Description#>
    ///
    /// - Parameter rectangleResult: <#rectangleResult description#>
    /// - Returns: <#return value description#>
    @discardableResult private  func displayRectangleResult(rectangleResult: RectangleDetectorResult) -> Quadrilateral {
        displayedRectangleResult = rectangleResult
        
        let quad = rectangleResult.rectangle.toCartesian(withHeight: rectangleResult.imageSize.height)
        
        DispatchQueue.main.async { [weak self] in
            guard self != nil else {
                return
            }
            
        }
        
        return quad
    }
    
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func uploadAction(_ sender: UIButton) {
        UserDefaults.standard.set("Upload", forKey: AppConstants.Defaults.Key.AddExpenseType)
        
        
        alert.dismiss(animated: true, completion: nil)
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    ///
    /// - Parameter animated: If true, the view is being added to the window using an animation.

    override func viewWillAppear(_ animated: Bool) {
        imagePicker.delegate = self
    }
    /// Called after the controller's view is loaded into memory.

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /// <#Description#>
    ///
    /// - Parameter imageData: <#imageData description#>
    /// - Returns: <#return value description#>
    func metadata(fromImageData imageData: Data?) -> [AnyHashable: Any]? {
        if let imageSource = CGImageSourceCreateWithData((imageData)! as CFData, nil) {
            let options = [kCGImageSourceShouldCache as String: (0)]
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (options as CFDictionary?)!) {
            let metadata = imageProperties as? [AnyHashable: Any]
            if let aMetadata = metadata {
                print("Metadata of selected image\(aMetadata)")
            }
            return metadata
        }
        
        }
        print("Can't read metadata")
        return nil
    }
    
    
}
// MARK: - UIImagePickerControllerDelegate
extension UploadViewController: UIImagePickerControllerDelegate {
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - picker: <#picker description#>
    ///   - info: <#info description#>
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imageView.image = image
        
        if imageView.image != nil {
            //
            let crop = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.EditScanViewController) as? EditScanViewController
            crop?.image = imageView.image
            
            if let aCrop = crop {
                self.present(aCrop, animated: true)
            }
            
            
            
        }
    }
    
    
    /// <#Description#>
    ///
    /// - Parameter picker: <#picker description#>
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate
extension UploadViewController: UINavigationControllerDelegate {
    
}
/// <#Description#>
private struct RectangleDetectorResult {
    
    /// <#Description#>
    let rectangle: Quadrilateral
    
    /// <#Description#>
    let imageSize: CGSize
    
}
