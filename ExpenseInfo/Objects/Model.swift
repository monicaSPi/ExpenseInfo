
import Foundation
import AVFoundation
import Vision
import UIKit
import Photos

/// Data structure containing information about Expense List
struct ExpenseListInfo  {
    ///  unique id for an Expense
    var id : String?
    ///  Mode of Expense added to the list
    var expenseMode : String?
    ///  default currency symbol
    var currencySymbolString : String?
    ///  time of Expense
    var time : String?
    ///  Captured BillImage if available in Data Format
    var billImg : Data?
    /// Represents whether the expense is reimburseable or not with Boolean
    var reimbursable : Bool?
    /// Represents any important note available not mandatory
    var notes : String?
    ///  Total amount of the expense in Double Type
    var totalAmount : Double?
    ///  Merchant name of an Expense made
    var merchantName : String?
    ///  Currency symbol of the Expense made
    var currencySymbol : String?
    ///  date of the Expense
    var date : String?
    ///  User ID
    var userId : String?
    ///  Category Image in Data Format
    var categoryImg : Data?
    ///  Expense Amount
    var amount : String?
    /// Represents if the expense is claimed or not
    var claimed : String?
    ///  Expense category
    var category : String?
    ///  Expense Type ID
    var expenseTypeId : Int16?
    /// Expense Heading
    var expenseHeading : String?
    ///  Tags for the expense in Array of Strings
    var tags : [String]?
    
}


/// Data structure containing information about Expense Category
struct ExpenseCategory  {
    
    /// Expense category ID
    var categoryId : String?
    /// Expense category Name
    var categoryName : String?
    /// Expense category Image Name
    var categoryImg : String?
    /// Expense category Color
    var categoryColor : String?
    
}

/// Data structure containing information about UI Constants.
public struct UI {
    /// The rowHeight of UITableView in Country Picker
    static let rowHeight = CGFloat(50)
    /// The seperator color of UITableView in Country Picker
    static let separatorColor: UIColor = UIColor.lightGray.withAlphaComponent(0.4)
}

/// Data structure containing information about sending a bill in email as attachment.
struct EmailBill {
    /// image Name
    var name: String?
    /// image in Data format
    var image: Data?
}
/// Data structure containing information about a scan.
public struct ImageScannerResults {
    
    /// The original image taken by the user, prior to the cropping applied by WeScan.
    public var originalImage: UIImage
    
    /// The deskewed and cropped orignal image using the detected rectangle, without any filters.
    public var scannedImage: UIImage
    
    /// The enhanced image, passed through an Adaptive Thresholding function. This image will always be grayscale and may not always be available.
    public var enhancedImage: UIImage?
    
    /// Whether the user wants to use the enhanced image or not. The `enhancedImage`, for use with OCR or similar uses, may still be available even if it has not been selected by the user.
    public var doesUserPreferEnhancedImage: Bool
    
    /// The detected rectangle which was used to generate the `scannedImage`.
    public var detectedRectangle: Quadrilateral
    
}

/// Data structure containing information about Image Rectangle Detection
struct CIRectangleDetector {
    
    static let rectangleDetector = CIDetector(ofType: CIDetectorTypeRectangle, context: CIContext(options: nil), options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
    
    /// Detects rectangles from the given image on iOS 10.
    ///
    /// - Parameters:
    ///   - image: The image to detect rectangles on.
    /// - Returns: The biggest detected rectangle on the image.
    static func rectangle(forImage image: CIImage, completion: @escaping ((Quadrilateral?) -> Void)) {
        
        let biggestRectangle = rectangle(forImage: image)
        completion(biggestRectangle)
    }
    
    /// Detects rectangles from the given image on iOS 10.
    ///
    /// - Parameters:
    ///   - image: The image to detect rectangles on.
    /// - Returns: The Quadirateral with rectangle feature.
    static func rectangle(forImage image: CIImage) -> Quadrilateral? {
        
        guard let rectangleFeatures = rectangleDetector?.features(in: image) as? [CIRectangleFeature] else {
            return nil
        }
        
        let quads = rectangleFeatures.map { rectangle in
            return Quadrilateral(rectangleFeature: rectangle)
        }
        
        return quads.biggest()
    }
}
@available(iOS 11.0, *)
/// Data structure containing information about Rectangle detection in a Image Captured
struct VisionRectangleDetector {
    
    /// Detects rectangles from the given image on iOS 11 and above.
    ///
    /// - Parameters:
    ///   - image: The image to detect rectangles on.
    /// - Returns: The biggest rectangle detected on the image.
    static func rectangle(forImage image: CIImage, completion: @escaping ((Quadrilateral?) -> Void)) {
        
        let imageRequestHandler = VNImageRequestHandler(ciImage: image, options: [:])
        
        /// Create the rectangle request, and, if found, return the biggest rectangle (else return nothing).
        let rectangleDetectionRequest: VNDetectRectanglesRequest = {
            let rectDetectRequest = VNDetectRectanglesRequest(completionHandler: { (request, error) in
                guard error == nil,
                    let results = request.results as? [VNRectangleObservation],
                    !results.isEmpty else {
                        completion(nil)
                        return
                }
                
                let quads: [Quadrilateral] = results.map({ observation in
                    return Quadrilateral(topLeft: observation.topLeft, topRight: observation.topRight, bottomRight: observation.bottomRight, bottomLeft: observation.bottomLeft)
                })
                
                guard let biggest = results.count > 1 ? quads.biggest() : quads.first else { return }
                
                let transform = CGAffineTransform.identity
                    .scaledBy(x: image.extent.size.width, y: image.extent.size.height)
                
                let finalRectangle = biggest.applying(transform)
                
                completion(finalRectangle)
            })
            
            rectDetectRequest.minimumConfidence = 0.8
            rectDetectRequest.maximumObservations = 15
            
            return rectDetectRequest
        }()
        
        /// Send the requests to the request handler.
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform([rectangleDetectionRequest])
            } catch {
                completion(nil)
                return
            }
        }
    }
    
}

/// Data structure containing information about Locale
public struct LocaleInfo {
    
    
    /// Locales are typically used to provide, format, and interpret information about and according to the user's customs and preferences. They are frequently used in conjunction with formatters. Although you can use many locales, you usually use the one associated with the current user.
    public var locale: Locale?
    
    
    /// Locale with an identifier
    public var id: String? {
        return locale?.identifier
    }
    
    /// represents country name
    public var country: String
    
    /// represents country code
    public var code: String
    
    /// represents phone code
    public var phoneCode: String
    
    /// represents country flag image returns
    public var flag: UIImage? {
        return UIImage(named: "Countries.bundle/Images/\(code.uppercased())", in: Bundle.main, compatibleWith: nil)
    }
    
    /// represents currency code
    public var currencyCode: String? {
        return locale?.currencyCode
    }
    
    /// represents currency symbol
    public var currencySymbol: String? {
        return locale?.currencySymbol
    }
    
    
    /// represents currency name
    public var currencyName: String? {
        guard let currencyCode = currencyCode else { return nil }
        return locale?.localizedString(forCurrencyCode: currencyCode)
    }
    
    
    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    ///
    /// - Parameters:
    ///   - country: countryName
    ///   - code: countryCode
    ///   - phoneCode: countryPhoneCode
    init(country: String, code: String, phoneCode: String) {
        self.country = country
        self.code = code
        self.phoneCode = phoneCode
        
        self.locale = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first(where: { $0.regionCode == code })
    }
}
struct LocaleStore {
    
    /// Result Enum
    ///
    /// - Success: Returns Grouped By Alphabets Locale Info
    /// - Error: Returns error
    public enum GroupedByAlphabetsFetchResults {
        case success(response: [String: [LocaleInfo]])
        case error(error: (title: String?, message: String?))
    }
    
    /// Result Enum
    ///
    /// - Success: Returns Array of Locale Info
    /// - Error: Returns error
    public enum FetchResults {
        case success(response: [LocaleInfo])
        case error(error: (title: String?, message: String?))
    }
    
    /// This method is used to get countries information from the country bundle
    ///
    /// - Parameter completionHandler: FetchResult with
    /// - Success: Returns Array of Locale Info
    /// - Error: Returns error
    public static func getInfo(completionHandler: @escaping (FetchResults) -> ()) {
        let bundle = Bundle(for: LocalePickerViewController.self)
        let path = "Countries.bundle/Data/CountryCodes"
        
        guard let jsonPath = bundle.path(forResource: path, ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
                let error: (title: String?, message: String?) = (title: "ContryCodes Error", message: "No ContryCodes Bundle Access")
                return completionHandler(FetchResults.error(error: error))
        }
        
        if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)) as? Array<Any> {
            var result: [LocaleInfo] = []
            for jsonObject in jsonObjects {
                guard let countryObj = jsonObject as? Dictionary<String, Any> else { continue }
                guard let country = countryObj["name"] as? String,
                    let code = countryObj["code"] as? String,
                    let phoneCode = countryObj["dial_code"] as? String else {
                        continue
                }
                
                
                
                let new = LocaleInfo(country: country, code: code, phoneCode: phoneCode)
                result.append(new)
            }
            
            
            return completionHandler(FetchResults.success(response: result))
        }
        
        let error: (title: String?, message: String?) = (title: "JSON Error", message: "Couldn't parse json to Info")
        return completionHandler(FetchResults.error(error: error))
    }
    
    /// This method fetches the data from the result and if success set it to the completion handler block
    ///
    /// - Parameter completionHandler: To call GroupedByAlphabetsFetchResults
    /// - Success: Returns Grouped By Alphabets Locale Info
    /// - Error: Returns error
    public static func fetch(completionHandler: @escaping (GroupedByAlphabetsFetchResults) -> ()) {
        LocaleStore.getInfo { result in
            switch result {
            case .success(let info):
                
                var data = [String: [LocaleInfo]]()
                
                info.forEach {
                    let country = $0.country
                    let index = String(country[country.startIndex])
                    var value = data[index] ?? [LocaleInfo]()
                    value.append($0)
                    data[index] = value
                }
                
                data.forEach { key, value in
                    data[key] = value.sorted(by: { lhs, rhs in
                        return lhs.country < rhs.country
                    })
                }
                completionHandler(GroupedByAlphabetsFetchResults.success(response: data))
                
            case .error(let error):
                completionHandler(GroupedByAlphabetsFetchResults.error(error: error))
            }
        }
    }
}

