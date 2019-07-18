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
    
    /// <#Description#>
    var fromCategory : Bool = false
    
    /// <#Description#>
    var currencySymbol : String = "$"

    /// <#Description#>
    var currencyCode : String = "USD"
    
    /// <#Description#>
    var tagsString : [String] = []
    
    /// <#Description#>
    var activeField: UITextField?
    
    /// <#Description#>
    var blockArray:NSMutableArray = []
    
    /// <#Description#>
    var isKeyboardUp: Bool = false
    
    /// <#Description#>
    var reimburseSwitch : Bool = false
    
    /// <#Description#>
    var gotTotal: Bool = false
    
    /// <#Description#>
    var textImages = [UIImage]()
    
    /// <#Description#>
    lazy var vision = Vision.vision()
    
    /// <#Description#>
    var lineArray : NSMutableArray = []
    
    /// <#Description#>
    var amountArray : NSMutableArray = []
    
    /// <#Description#>
    var amountArrayValue : NSMutableArray = []
    
    /// <#Description#>
    lazy var textRecognizer = vision.onDeviceTextRecognizer()
    
    /// <#Description#>
    var globalArray :NSMutableArray = []

    
   
    /// <#Description#>
    ///
    /// - Parameter inputImage: <#inputImage description#>
    /// - Returns: <#return value description#>
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
