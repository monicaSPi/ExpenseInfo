

import UIKit
import SafariServices
import Photos
import Foundation

import CoreTelephony
import MobileCoreServices


/// This View Controller is used to open the gallery and pick the image from the device
class UploadViewController: UIViewController {
    
    /// imageView that displays a single image or a sequence of animated images in your interface.
    @IBOutlet var imageView: UIImageView!
    
    /// imagePicker that manages the system interfaces for taking pictures, recording movies, and choosing items from the user's media library.
    var imagePicker = UIImagePickerController()
    
    /// viewController that manages a view hierarchy for your UIKit app.
    var viewController: UIViewController?
    
    /// This is called after the image is plicked from the gallary
    var pickImageCallback : ((UIImage) -> ())?;
    
    /// Data Structure for RectangleDetector Result
    private var displayedRectangleResult: RectangleDetectorResult?
    
    /// uploadBtn that executes your custom code in response to user interactions.
    @IBOutlet weak var uploadBtn: UIButton! {
        didSet {
            uploadBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            uploadBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            uploadBtn.layer.shadowOpacity = 1.0
            uploadBtn.layer.shadowRadius = 10.0
            uploadBtn.layer.masksToBounds = false
            
        }
    }
    
    /// alert that displays an alert message to the user.
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    
    /// This method dismiss the view controller from the navigation stack
    ///
    /// - Parameter sender: sender id
    @IBAction func cloaseAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    /// This method is used to open the ImagePickerController
    ///
    /// - Parameter sender: sender id
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
    
    
    
}
// MARK: - UIImagePickerControllerDelegate
extension UploadViewController: UIImagePickerControllerDelegate {
    /// Tells the delegate that the user picked a still image or movie.
    ///
    /// - Parameters:
    ///   - picker: The controller object managing the image picker interface.
    ///   - info: A dictionary containing the original image and the edited image, if an image was picked; or a filesystem URL for the movie, if a movie was picked. The dictionary also contains any relevant editing information. The keys for this dictionary are listed in Editing Information Keys.
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
    
    
    /// Tells the delegate that the user cancelled the pick operation.
    ///
    /// - Parameter picker: The controller object managing the image picker interface.
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate
extension UploadViewController: UINavigationControllerDelegate {
    
}
/// Data Structure for RectangleDetector Result
private struct RectangleDetectorResult {
    
    /// rectangle is Instance of Quadrilateral
    let rectangle: Quadrilateral
    
    /// size of the image
    let imageSize: CGSize
    
}
