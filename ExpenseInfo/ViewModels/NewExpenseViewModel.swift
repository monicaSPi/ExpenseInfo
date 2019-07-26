//
//  NewExpenseViewModel.swift
//  ExpenseInfo
//
//  Created by lw-dlf on 4/12/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import UIKit
import DatePickerDialog
import LLSwitch
import WSTagsField
import Vision
import Firebase
import FirebaseMLVision
import CoreData


/// ViewModel class of `AddNewExpenseViewController`
class NewExpenseViewModel {
    
    /// fromCategory whose instances are either true or false.
    var fromCategory : Bool = false
    
    /// default Currency Symbol
    var currencySymbol : String = "$"
    
    /// default currency code
    var currencyCode : String = "USD"
    
    /// tagsString is the array of strings
    var tagsString : [String] = []
    
    /// indicates which textField is active
    var activeField: UITextField?
    
    /// Ocr result based on blocks is stored in this array
    var blockArray:NSMutableArray = []
    
    /// isKeyboardUp whose instances are either true or false.
    var isKeyboardUp: Bool = false
    
    ///  reimburseSwitch whose instances are either true or false.
    var reimburseSwitch : Bool = false
    
    ///  gotTotal of the expense whose instances are either true or false.
    var gotTotal: Bool = false
    
    
    
    /// Gets an instance of Firebase Vision service for the default Firebase app. The default Firebase app instance must be configured before calling this method; otherwise, raises FIRAppNotConfigured exception.
    lazy var vision = Vision.vision()
    
    ///  Ocr result based on each line is stored in this array
    var lineArray : NSMutableArray = []
    
    /// This array represents amount Array
    var amountArray : NSMutableArray = []
    
    /// This array represents amount Value array
    var amountArrayValue : NSMutableArray = []
    
    /// Gets an on-device text recognizer from Firebase Vision
    lazy var textRecognizer = vision.onDeviceTextRecognizer()
    
    /// This array is used to represent the global values required for the application
    var globalArray :NSMutableArray = []
    
    
    
    /// This method is used to scan the image and perform openGLES2 operation and return the image
    ///
    /// - Parameter inputImage: inputImage to be scanned
    /// - Returns: return scanned image
    func getScannedImage(inputImage: UIImage) -> UIImage? {
        
        let openGLContext = EAGLContext(api: .openGLES2)
        let context = CIContext(eaglContext: openGLContext!)
        
        let filter = CIFilter(name: "CIColorControls")
        let coreImage = CIImage(image: inputImage)
        
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(20.0, forKey: kCIInputContrastKey)
        filter?.setValue(0.0, forKey: kCIInputSaturationKey)
        filter?.setValue(1.2, forKey: kCIInputBrightnessKey)
        
        if let outputImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let output = context.createCGImage(outputImage, from: outputImage.extent)
            return UIImage(cgImage: output!)
        }
        return nil
    }
    
    
    
    /// Set Orientation for `UIImage` given
    ///
    /// - Parameter image: image for the orientation process
    /// - Returns: return image with the appropriate orientation
    func fixOrientation(image: UIImage) -> UIImage {
        if image.imageOrientation == UIImage.Orientation.up {
            return image
        }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return image
        }
    }
}
