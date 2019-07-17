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


/// <#Description#>
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
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - top_image: <#top_image description#>
    ///   - bottom_image: <#bottom_image description#>
    ///   - top_image_point: <#top_image_point description#>
    ///   - isHaveBackground: <#isHaveBackground description#>
    /// - Returns: <#return value description#>
    func mixImage(top_image:UIImage, bottom_image:UIImage, top_image_point:CGPoint=CGPoint.zero, isHaveBackground:Bool = true)-> UIImage{
        let bottomImage = bottom_image//self.Camera_Image_View.image
        let newSize = bottomImage.size // set this to what you need
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        if(isHaveBackground==true){
            bottomImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        }
        top_image.draw(in: CGRect(origin: top_image_point, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return newImage!
    }
    
    /// <#Description#>
    ///
    /// - Parameter image: <#image description#>
    /// - Returns: <#return value description#>
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
