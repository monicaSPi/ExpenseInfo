

import UIKit
import DatePickerDialog
import LLSwitch
import WSTagsField
import Vision
import Firebase
import FirebaseMLVision
import CoreData

// MARK: - LLSwitchDelegate
extension AddNewExpenseViewController : LLSwitchDelegate {

    
    /// This method is called when a toggle switch changes its value
    ///
    /// - Parameters:
    ///   - llSwitch: Aminated UIView
    ///   - on: toggle between the reimbursement switch value either true or false
    func valueDidChanged(_ llSwitch: LLSwitch?, on: Bool) {
        newExpenseViewModel.reimburseSwitch = on ? true : false
    }
}

// MARK: - CategoryInfoDelegate
extension AddNewExpenseViewController: CategoryInfoDelegate {
  
    
   
    /// This method is used to get imformation from the `ExpenseCategoryViewController`
    ///
    /// - Parameters:
    ///   - name: The category name
    ///   - image: category image
    ///   - id: category unique id
    ///   - color: category color
    func categoryInformation(name: String, image: String, id: String , color: String) {
        category.text = name
        categoryImg.image = UIImage(named: image)
        catId.text = id
        catColor.text = color
        newExpenseViewModel.fromCategory = true
    }
}

/**
 Tells the delegate that editing began in the specified text field.
 
 - parameter textField: The text field in which an editing session began.
 */

// MARK: - UITextFieldDelegate
extension AddNewExpenseViewController: UITextFieldDelegate {
    
    
    /// Tells the delegate that editing stopped for the specified text field.
    ///
    /// - Parameter textField: The text field for which editing ended.
    func textFieldDidEndEditing(_ textField: UITextField) {
        newExpenseViewModel.activeField = nil
    }
    
    
    /// Tells the delegate that editing began in the specified text field.
    ///
    /// - Parameter textField: The text field in which an editing session began.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        newExpenseViewModel.activeField = textField
        if merchant.text != "" {
            merchantIcon.setImage(UIImage(named: "merchant-list-color"), for: .normal)//imageView?.image =
        }
        if textField == notes {
            let beginning: UITextPosition = textField.beginningOfDocument
            textField.selectedTextRange = textField.textRange(from: beginning, to: beginning)
        }
    }
    
    
    
    /// Asks the delegate if editing should begin in the specified text field.
    ///
    /// - Parameter textField: The text field in which editing is about to begin.
    /// - Returns: true if editing should begin or false if it should not.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if merchant.text != "" {
            merchantIcon.setImage(UIImage(named: "merchant-list-color"), for: .normal)
        }
        if textField == date {
            datePickerTapped()
            textField.resignFirstResponder()
            return false
        }
        if textField == time  {
            timePickerTapped()
            textField.resignFirstResponder()
            return false
        }
        if textField == category  {
            openExpenseCategory()
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    

    /// Asks the delegate if the specified text should be changed.
    ///
    /// - Parameters:
    ///   - textField: The text field containing the text.
    ///   - range: The range of characters to be replaced.
    ///   - string: The replacement string for the specified range. During typing, this parameter normally contains only the single new character that was typed, but it may contain more characters if the user is pasting text. When the user deletes one or more characters, the replacement string is empty.
    /// - Returns: true if the specified text range should be replaced; otherwise, false to keep the old text.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
        
    }
    
    
    /// Asks the delegate if the text field should process the pressing of the return button.
    ///
    /// - Parameter textField: The text field whose return button was pressed.
    /// - Returns: true if the text field should implement its default behavior for the return button; otherwise, false.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
        }
        
        
        return false
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension AddNewExpenseViewController : UIViewControllerTransitioningDelegate {
    
}

// MARK: - UITextViewDelegate
extension AddNewExpenseViewController : UITextViewDelegate {
    
    /// Asks the delegate whether the specified text should be replaced in the text view.
    ///
    /// - Parameters:
    ///   - textView: The text view containing the changes.
    ///   - range: The current selection range. If the length of the range is 0, range reflects the current insertion point. If the user presses the Delete key, the length of the range is 1 and an empty string object replaces that single character.
    ///   - text: The text to insert.
    /// - Returns: true if the old text should be replaced by the new text; false if the replacement operation should be aborted.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /// Asks the delegate if editing should stop in the specified text view.
    ///
    /// - Parameter textView: The text view for which editing is about to end.
    /// - Returns: true if editing should stop; otherwise, false if the editing session should continue
    func textViewShouldReturn(textView: UITextView!) -> Bool {
        self.view.endEditing(true);
        return true;
    }
    
    /// Asks the delegate whether the specified text should be replaced in the text view.
    ///
    /// - Parameters:
    ///   - textView: The text view containing the changes.
    ///   - range: The current selection range. If the length of the range is 0, range reflects the current insertion point. If the user presses the Delete key, the length of the range is 1 and an empty string object replaces that single character.
    ///   - text: The text to insert.
    /// - Returns: true if the old text should be replaced by the new text; false if the replacement operation should be aborted.
    

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /// Tells the delegate that editing of the specified text view has ended.
    ///
    /// - Parameter textView: The text view in which editing ended.
    func textViewDidEndEditing(_ textView: UITextView) {
        newExpenseViewModel.activeField = nil
    }
    
}

/// User can populate the information about the expense made either Automatically by the captured receipt image or enter manually
class AddNewExpenseViewController: UIViewController {
    
    // MARK: IBOutlet Properties
    
    /// category ID Label to get Category ID
    @IBOutlet weak var catId: UILabel!
    
    /// category color label to get category Color
    @IBOutlet weak var catColor: UILabel!
    
    ///merchantIcon Button to show merchant is selected
    @IBOutlet weak var merchantIcon: UIButton!
    
    /// Bill imageView which is hidden on the UI
    @IBOutlet weak var imageView: UIImageView!
    
    /// Date textfield for fetch the date from the Bill image or to manually enter a date using date picker
    @IBOutlet weak var date: UITextField!
    
    /// Helps to add n number of Tags for the expense
    @IBOutlet weak var tagsView: UIView!
    
    /// Scroll view helps to scroll the UI top to bottom / bottom to top it depends on the device screen size
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// merchant Textfield contains merchantName either automatically captured from the Reciept image / manually selected from the merchant picker
    @IBOutlet weak var merchant: UITextField!
    
    /// time textField has time stamp either automatically captured from the Reciept image / manually selected from the Time picker
    @IBOutlet weak var time: UITextField!
    
    /// category Name is displayed in category Textfield, can select the category by nativating to `ExpenseCategoryViewController`
    @IBOutlet weak var category: UITextField!
    
    /// categoryImage from `ExpenseCategoryViewController` is displayed when the category is selected
    @IBOutlet weak var categoryImg: UIImageView!
    
    /// expense Amount is displayed in the amount textfield by either automatically capturing from the bill or manually enter the amount
    @IBOutlet weak var amount: UITextField!
    
    /// reimbursement LLSwitch view is to toggle between the reimbursement option for the expense
    @IBOutlet weak var reimbursement: LLSwitch!
    
    /// notes textview is to write any important note on the expense made
    @IBOutlet weak var notes: UITextView!
    
    /// currency Button is to change the default Currency by selecting from a currency picker
    @IBOutlet weak var currency: UIButton!
    
    // MARK: - Local variable
    
    /// ViewModel instance of this controller
    let newExpenseViewModel = NewExpenseViewModel()
    // MARK: - File private
    
    
    
    /// <#Description#>
    private lazy var annotationOverlayView: UIView = {
        precondition(isViewLoaded)
        let annotationOverlayView = UIView(frame: .zero)
        annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return annotationOverlayView
    }()
    
    /// <#Description#>
    private func removeDetectionAnnotations() {
  
        annotationOverlayView.subviews.forEach { (annotationView) in
            annotationView.removeFromSuperview()
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - frame: <#frame description#>
    ///   - color: <#color description#>
    ///   - transform: <#transform description#>
    private func drawFrame(_ frame: CGRect, in color: UIColor, transform: CGAffineTransform) {
        let transformedRect = frame.applying(transform)
        UIUtilities.addRectangle(
            transformedRect,
            to: self.annotationOverlayView,
            color: color
        )
    }
    
    
    /// <#Description#>
    fileprivate let tagsField = WSTagsField()
    
    /// Delegate for the Tag View when it is added , removed, changed, adjust height, select tag, unselect tag
    fileprivate func textFieldEvents() {
        
        tagsField.onDidAddTag = { _, tagValue in
            self.newExpenseViewModel.tagsString.append("\(tagValue.text)")
        }
        
        tagsField.onDidRemoveTag = { _, tag in
            self.newExpenseViewModel.tagsString.removeAll("\(tag.text)")
            print("onDidRemoveTag")
        }
        
        tagsField.onDidChangeText = { _, text in
            print("onDidChangeText \(String(describing: text))")
        }
        
        tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
        }
        
        tagsField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }
        
        tagsField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }
    }
    // MARK: Default View Controller Methods
    
    /// Called after the controller's view is loaded into memory.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let currencyCode1 = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.CurrencyCode) {
            newExpenseViewModel.currencyCode = currencyCode1 as! String
        }
        if let currencySymbol1 = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.CurrencySymbol) {
            newExpenseViewModel.currencySymbol = currencySymbol1 as! String
        }
        
        self.currency.setTitle(newExpenseViewModel.currencyCode, for: .normal)
        
        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)
        reimbursement.delegate = self
        
        tagsField.translatesAutoresizingMaskIntoConstraints = false
        tagsField.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        tagsField.spaceBetweenLines = 10
        tagsField.spaceBetweenTags = 10
        
        notes.delegate = self
        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        tagsField.placeholder = "Enter a tag"
        tagsField.placeholderColor = UIColor(hexString: "687792")
        tagsField.placeholderAlwaysVisible = false
        tagsField.backgroundColor = .clear
        tagsField.returnKeyType = .done
        tagsField.delimiter = ""
        tagsField.font = UIFont(name: "MyriadPro-Regular", size: 18.0)
        tagsField.textColor = UIColor(hexString: "2F3C4B")//UIColor(hexString: "426891")
        tagsField.fieldTextColor = UIColor(hexString: "2F3C4B")
        tagsField.selectedColor = UIColor(hexString: "DADEEB")
        tagsField.selectedTextColor = UIColor(hexString: "2F3C4B")
        tagsField.tintColor = UIColor(hexString: "DADEEB")
        tagsField.textDelegate = self
        tagsField.acceptTagOption = .space
        
        textFieldEvents()
        let currentdate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: currentdate)
        date.text = result
        
        
        
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        let currentTime = formatter.string(from: Date())
        
        print(currentTime)
        time.text = currentTime
        
        let type = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.AddExpenseType) as! String
        
        if type == "Edit" {
            
            
            reimbursement.setOn(newExpenseViewModel.reimburseSwitch, animated: true)
        }
        if type == "Manual" {
            UserDefaults.standard.setValue(nil, forKey: AppConstants.Defaults.Key.DisplayImg)
            UserDefaults.standard.synchronize()
        }
        if (type != "Manual" && type != "Edit") {
            EZLoadingActivity.show("ocr ....", disableUI: true)
            if let displayIMgs = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.DisplayImg)  {
                
                
                let billimage = UIImage(data: displayIMgs as! Data)
                _ = newExpenseViewModel.fixOrientation(image:billimage!)
                if let imagePath = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.ReceiptImg) {
                    
                    
                    imageView.image = UIImage(data: imagePath as! Data)
                    
                    
                    firstTask { (success) -> Void in
                        if success {
                            _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(AddNewExpenseViewController.ocrUpdate), userInfo: nil, repeats: false)
                        }
                    }
                    
                }
            }
        }
        
        
    }
    
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    ///
    /// - Parameter animated: If true, the view is being added to the window using an animation.
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                              target: self, action:#selector(self.doneButtonAction))
        
        toolbarDone.items = [barBtnDone]
        amount.inputAccessoryView = toolbarDone
        reimbursement.delegate = self
        let type = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.AddExpenseType) as! String
        
        if type == "Edit" {
            
            merchantIcon.setImage(UIImage(named: "merchant-list-color"), for: .normal)
            
            if !newExpenseViewModel.fromCategory {
                getExpenseforEdit()
            }
        }
        
    }
    
    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    ///
    /// - Parameter animated: If true, the disappearance of the view is being animated.
    override func viewWillDisappear(_ animated: Bool) {
        newExpenseViewModel.fromCategory = false
    }
    
    /// Called to notify the view controller that its view has just laid out its subviews.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tagsField.frame = tagsView.bounds
    }
    
    /// Notifies the view controller that its view was removed from a view hierarchy.
    ///
    /// - Parameter animated: If true, the disappearance of the view was animated.
    override func viewDidDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
   
    // MARK: - Image Transform
    
    /// This method helps an affine transformation matrix is used to rotate, scale, translate, or skew the objects you draw in a graphics context
    ///
    /// - Returns: An affine transformation matrix for use in drawing 2D graphics.
    private func transformMatrix() -> CGAffineTransform {
        guard let image = imageView.image else { return CGAffineTransform() }
        let imageViewWidth = imageView.frame.size.width
        let imageViewHeight = imageView.frame.size.height
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let imageViewAspectRatio = imageViewWidth / imageViewHeight
        let imageAspectRatio = imageWidth / imageHeight
        let scale = (imageViewAspectRatio > imageAspectRatio) ?
            imageViewHeight / imageHeight :
            imageViewWidth / imageWidth
        let scaledImageWidth = imageWidth * scale
        let scaledImageHeight = imageHeight * scale
        let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
        let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)
        
        var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
        transform = transform.scaledBy(x: scale, y: scale)
        return transform
    }
    
    
 
    
    
    // MARK: - OCR Update
    
    
    
    /**
     
     This method helps to iterate the blockArray and extract the Amount value from the OCR result Array
     
     By applying complex predicate to find the Amount of the Expense made throught the captured Bill Image
     
     */
    @objc func ocrUpdate() {
        print("Total Array ============================>  \(newExpenseViewModel.lineArray)")
        print("Bloacks =====================> \(newExpenseViewModel.blockArray)")
        
        for (_ , value) in newExpenseViewModel.blockArray.enumerated() {
            
            if newExpenseViewModel.gotTotal {
                print("Total============> :\(value)")
            }
            if (( (value as! String).lowercased()).contains("total") ||  ((value as! String).lowercased()).contains("net")  || ((value as! String).lowercased()).contains("tend") || ((value as! String).lowercased()).contains("card") || ((value as! String).lowercased()).contains("amount")) {
                newExpenseViewModel.gotTotal = true
                
            }
            
            
            
        }
        
        
        //        var cassPaid : Bool = false
        if newExpenseViewModel.lineArray.count > 0 {
            for (index , value) in newExpenseViewModel.lineArray.enumerated() {
                var string: String = value as! String
                if (string as AnyObject).contains(".") {
                    string = string.trimmingCharacters(in: .whitespaces)
                    string = string.replacingOccurrences(of: "$ ", with: "", options: NSString.CompareOptions.literal, range: nil)
                    string = string.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
                    string = string.replacingOccurrences(of: ",", with: ".", options: NSString.CompareOptions.literal, range: nil)
                    
                    let intValues = Float(string)
                    //                    print("exists  \(intValues)")
                    if intValues > 0 {
                        if let i = intValues {
                            print("Amounts Float ===============> \(i)")
                            
                            let roundedString = String(format: "%.2f", i)
                            newExpenseViewModel.amountArray.add(index)
                            newExpenseViewModel.amountArrayValue.add(roundedString)
                            if (roundedString == String(i)) {
                                print("Amounts ===============> \(roundedString)")
                            }
                        } else {
                            // Tell user the value is invalid
                        }
                    }
                }
                
            }
            
        }
        print("Amounts ===============> \(newExpenseViewModel.amountArrayValue)")
        print(newExpenseViewModel.amountArray)
        let totalArrayCount : NSMutableArray = []
        
        
        if newExpenseViewModel.amountArrayValue.count > 0 {
            
            newExpenseViewModel.amountArrayValue.forEach { (val) in
                let valueString = val as! String
                var topValue = valueString.trimmingCharacters(in: .whitespaces)
                topValue = topValue.replacingOccurrences(of: "$ ", with: "", options: NSString.CompareOptions.literal, range: nil)
                topValue = topValue.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
                topValue = topValue.replacingOccurrences(of: ",", with: ".", options: NSString.CompareOptions.literal, range: nil)
                
                if let tipFloatValue = Float(topValue)  {
                    totalArrayCount.add(tipFloatValue)
                }
            }
        }
        print(totalArrayCount)
        var counts: [Float: Int] = [:]
        
        for item in totalArrayCount as! [Float]{
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        print("Amount : \(counts)")  
        
        for (key, value) in counts {
            print("\(key) occurs \(value) time(s)")
        }
        var restAmount : [Float] = []
        var findTotAmount : [Float] = []
        var totalAmountValue : Float = 0.00
        
        for (key,_) in counts {
            findTotAmount.append(key)
        }
        
        if findTotAmount.count > 0 {
            totalAmountValue = findTotAmount.max()!
            amount.text = " \(totalAmountValue)"
            counts.removeValue(forKey: totalAmountValue)
        }
        
        for (key,_) in counts {
            
            restAmount.append(key)
        }
        
        print(counts)
        EZLoadingActivity.hide()
        
    }
    
    
   
    /// This method is used to send the image for text recognition
    ///
    /// - Parameter completion: returns true after completion of text Recognition
    func firstTask(completion: (_ success: Bool) -> Void) {
        if let imagePath = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.ReceiptImg)  {
            
            
            imageView.image = UIImage(data: imagePath as! Data)
            
            
            let billimage = imageView.image
            var realImage = newExpenseViewModel.getScannedImage(inputImage: billimage!)
            imageView.image = billimage
            guard let cgImage = realImage?.cgImage,
                let initialOrientation = realImage?.imageOrientation,
                let filter = CIFilter(name: "CIPhotoEffectNoir")
                else { return }
            let sourceImage = CIImage(cgImage: cgImage)
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            let context = CIContext(options: nil)
            guard let outputImage = filter.outputImage,
                let cgImageOut = context.createCGImage(outputImage, from: outputImage.extent)
                else { return }
            let imageview = UIImageView()
            imageview.image = billimage
            realImage = UIImage(cgImage: cgImageOut, scale: 1, orientation: initialOrientation)
            
            runTextRecognition(with: imageView.image!)
        }
        completion(true)
    }
    
   
//    func textDetect(dectect_image:UIImage, display_image_view:UIImageView)->UIImage{
//        let handler:VNImageRequestHandler = VNImageRequestHandler.init(cgImage: (dectect_image.cgImage)!)
//        let result_img:UIImage = UIImage.init();
//        let request:VNDetectTextRectanglesRequest = VNDetectTextRectanglesRequest.init(completionHandler: { (request, error) in
//            if( (error) != nil){
//                print("Got Error In Run Text Dectect Request");
//            }else{
//            }
//        })
//
//        request.reportCharacterBoxes = true
//        do {
//            try handler.perform([request])
//            return result_img;
//            //            print("Successful Run Text Dectect Request");
//        } catch {
//            return result_img;
//        }
//    }
//    func addScreenShotToTextImages(sourceImage image: UIImage, boundingBox: CGRect) {
//        let pct = 0.1 as CGFloat
//        let newRect = boundingBox.insetBy(dx: -boundingBox.width*pct/2, dy: -boundingBox.height*pct/2)
//
//        if let imageRef = image.cgImage!.cropping(to: newRect) {
//            let croppedImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
//            newExpenseViewModel.textImages.append(croppedImage)
//        }
//    }
   
    
    /// runTextRecognition method helps in process the given bill image to recognize the text using Vision Framework
    ///
    /// - Parameter image: billImage
    func runTextRecognition(with image: UIImage) {
        let visionImage = VisionImage(image: image)
        newExpenseViewModel.textRecognizer.process(visionImage) { features, error in
            self.processResult(from: features, error: error)
        }
    }
    
    
    /// processResult method helps in iterating all the blocks, lines and elements in the bill image done by Vision Framework
    ///
    /// - Parameters:
    ///   - text: extracted text from the billImage using VisionText
    ///   - error: error while no text is identified in Vision
    func processResult(from text: VisionText?, error: Error?) {
        removeDetectionAnnotations()
        guard error == nil, let text = text else {
            let errorString = error?.localizedDescription ?? AppConstants.Messages.detectionNoResultsMessage
            print("Text recognizer failed with error: \(errorString)")
            return
        }
        let transform = self.transformMatrix()
        
        text.blocks.forEach { (block) in
            drawFrame(block.frame, in: .purple, transform: transform)
            print("block ================================= > \(block.text)")
            newExpenseViewModel.blockArray.add(block.text)
            // Lines.
            
            block.lines.forEach({ (line) in
                drawFrame(line.frame, in: .orange, transform: transform)
                newExpenseViewModel.lineArray.add(line.text)
                merchant.text = newExpenseViewModel.lineArray[0] as? String
                merchantIcon.setImage(UIImage(named: "merchant-list-color"), for: .normal)//imageView?.image =
                
                print("Line ================================= > \(line.text)")
                // Elements.
                
                
                line.elements.forEach({ (element) in
                    drawFrame(element.frame, in: .green, transform: transform)
                    //  print("Element ================================= > \(element.text)")
                    self.isValidDate(dateString: element.text)
                    self.isValidTime(timeString: element.text)
                    let transformedRect = element.frame.applying(transform)
                    let label = UILabel(frame: transformedRect)
                    label.text = element.text
                    label.adjustsFontSizeToFitWidth = true
                    self.annotationOverlayView.addSubview(label)
                    
                })
            })
            
        }
    }
    
    
    /// Passing the string to check whether the string is in date format if so the assign and convert the dateString to date textfield with the expected date format
    ///
    /// - Parameter dateString: string from the OCR result
    func isValidDate(dateString: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm/dd/yy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        //according to date format your date string
        guard let date = dateFormatter.date(from: dateString) else {
            //  fatalError()
            return
        }
        print(date)
        dateFormatter.dateFormat = "MM/dd/yyyy" //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: date) //pass Date here
        print("Date=======================>   \(newDate)")
        self.date.text = newDate
        
    }
    
    /// Passing the string to check whether the string is in time format if so the assign and convert the timeString to time textfield with the expected time format
    ///
    /// - Parameter timeString: string from the OCR result
    func isValidTime(timeString: String) {
        let timeformatter = DateFormatter()
        
        
        
        
        
        //        print(dateString)
        
        if timeString.contains(":") {
            print("Time ============> \(timeString)")
            timeformatter.dateStyle = DateFormatter.Style.short
            if timeformatter.date(from: timeString) != nil {
                self.time.text = "\(timeString) PM"
                print("shortTime ============> \(timeString)")
            } else {
                timeformatter.dateStyle = DateFormatter.Style.medium
                if timeformatter.date(from: timeString) != nil {
                    self.time.text = "\(timeString) PM"
                    print("longTime ============> \(timeString)")
                    
                } else {
                    timeformatter.dateFormat = "HH:mm:ss"
                    let formatter1 = DateFormatter()
                    formatter1.dateFormat = "HH:mm "
                    //   print(dateString)
                    
                    if formatter1.date(from: timeString) != nil {
                        print("Time 2222  :=======>  \(timeString) PM")
                        self.time.text = "\(timeString) PM"
                    }
                    
                    
                    if timeformatter.date(from: timeString) != nil {
                        print("Time:=======>  \(timeString)")
                        self.time.text = "\(timeString) PM"
                    }
                }
            }
        }
        
        print(newExpenseViewModel.lineArray)
    }
    
    // MARK: IBAction Methods
    
    
    /// When merchantIcon is tapped shows the popup view of merchantList and the Keyboard is notified using NSNotification to perform required action
    ///
    /// - Parameter sender: merchantIcon id
    @IBAction func merchantListOpen(_ sender: UIButton) {
        
        deregisterFromKeyboardNotifications()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myNotification"), object: nil)
        
        
    }
    
    
    /// When currency button is tapped it opens the currency Picker View
    ///
    /// - Parameter sender: currency button id
    @IBAction func chooseCurrency(_ sender: UIButton) {
        currencyPickerOpen()
        
    }
    
    // MARK: - Custom Action
    
    /// UIBarButtonAction Target to resign the amount textfield responder
    @objc func doneButtonAction() {
        amount.resignFirstResponder()
    }
    
    /// This method updates the selected merchant name to merchant text field and change the merchant icon image when selected
    ///
    /// - Parameter merchantName: merchant name string
    func updatenewMerchant(merchantName : String) {
        merchant.text = merchantName
        merchantIcon.setImage(UIImage(named: "merchant-list-color"), for: .normal)//imageView?.image =
    }
    
    
    /// This method is called when the current viewcontroller is opened to edit the content
    /// Fetch the saved context of an expense from coredata using a expenselistarrayId predicated and iterate the result to populate the data in the uiview of the current viewcontroller
    
    func getExpenseforEdit() {
        let idString = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.expenseListArrayId) as? String
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch.predicate = NSPredicate(format: "id == %@", idString!)
        do {
            let fetchedtype = try AppConstants.managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            if fetchedtype.count == 1 {
                fetchedtype.forEach { (exp) in
                    currency.setTitle(exp.currencyCode, for: .normal)
                    date.text = exp.dateString
                    time.text = exp.timeString
                    merchant.text = exp.merchantName
                    merchantIcon.setImage(UIImage(named: "merchant-list-color"), for: .normal)//imageView?.image =
                    category.text = exp.expenseCategory
                    catId.text = exp.categoryId
                    catColor.text = exp.categoryColor
                    categoryImg.image = UIImage(data: exp.expenseCategoryImg!)
                    amount.text = exp.amount
                    newExpenseViewModel.reimburseSwitch = exp.reimbursable
                    self.reimbursement.setOn(newExpenseViewModel.reimburseSwitch, animated: true)
                    let share = exp.tags
                    configureTags(value: share as! [String])
                    print(exp.tags as? [String] as Any)
                    notes.text = exp.notes
                }
            } else {
            }
        } catch {
        }
    }
    
    /// This method is used to populate the tags field in the current view controller when it is in edit mode
    ///
    /// - Parameter value: array of tag strings
    func configureTags(value : [String])  {
        
        value.forEach { (val) in
            self.tagsField.addTag(val)
        }
    }
    
    
    /// This method is used to save the populated data of the expense to core data stack . By validating all the fields and check the mode of saving either as a new expense or edited expense
    func addnewExpenseNow() {
            
        let type = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.AddExpenseType) as! String
        
        
        
        if merchant.text != "" && date.text != "" && time.text != "" && category.text != "" && amount.text != ""   {
            
            
            
            let fetchedtype = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
            let idString = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.expenseListArrayId) as? String
            
            if type == "Edit" {
                
                fetchedtype.predicate = NSPredicate(format: "id == %@ ",idString! )
            }
            do {
                let fetchDefault = try AppConstants.managedObjectContext.fetch(fetchedtype) as! [ExpenseContent]
                if type == "Edit" {
                    if fetchDefault.count == 1 {
                        //
                        fetchDefault.forEach { (expenseContent) in
                            expenseContent.id = idString
                            expenseContent.merchantName = merchant.text
                            expenseContent.dateString = date.text
                            expenseContent.timeString = time.text
                            expenseContent.expenseCategory = category.text
                            expenseContent.reimbursable = newExpenseViewModel.reimburseSwitch
                            if let catimg =  categoryImg.image {
                                expenseContent.expenseCategoryImg  = catimg.pngData()
                            }
                            
                            expenseContent.currencySymbolString = newExpenseViewModel.currencySymbol
                            expenseContent.currencyCode = newExpenseViewModel.currencyCode
                            let trimmedString = amount.text!.trimmingCharacters(in: .whitespaces)
                            expenseContent.amount = trimmedString
                            expenseContent.notes = notes.text
                            expenseContent.categoryId = catId.text
                            expenseContent.categoryColor = catColor.text
                            expenseContent.tags = newExpenseViewModel.tagsString as NSObject
                            
                            
                            expenseContent.isClaimed = newExpenseViewModel.reimburseSwitch ? "NC" : "NA"
                            
                            
                            saveItems()
                        }
                        
                    }
                } else {
                    
                    
                    let expenseContent = NSEntityDescription.insertNewObject(forEntityName: "ExpenseContent", into: AppConstants.managedObjectContext) as! ExpenseContent
                    expenseContent.id = NSUUID().uuidString.lowercased()
                    expenseContent.merchantName = merchant.text
                    expenseContent.dateString = date.text
                    expenseContent.timeString = time.text
                    expenseContent.expenseCategory = category.text
                    expenseContent.reimbursable = newExpenseViewModel.reimburseSwitch
                    let type = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.AddExpenseType) as! String
                    
                    expenseContent.expenseMode = type
                    
                    if let catimg =  categoryImg.image {
                        expenseContent.expenseCategoryImg  = catimg.pngData()
                    }
                    
                    if let billimg =  imageView.image {
                        expenseContent.billImage  = billimg.pngData()
                    }
                    //
                    expenseContent.currencySymbolString = newExpenseViewModel.currencySymbol
                    expenseContent.currencyCode = newExpenseViewModel.currencyCode
                    //                  
                    expenseContent.isClaimed = newExpenseViewModel.reimburseSwitch ? "NC" : "NA"
                    
                    
                    expenseContent.categoryId = catId.text
                    expenseContent.categoryColor = catColor.text
                    let trimmedString = amount.text!.trimmingCharacters(in: .whitespaces)
                    
                    expenseContent.amount = trimmedString
                    expenseContent.notes = notes.text
                    expenseContent.tags = newExpenseViewModel.tagsString as NSObject
                    saveItems()
                }
                
            } catch {
                
                
            }
            
            
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ExpenseViewController) as? ExpenseViewController
            self.present(secondVC!, animated: true)
            
        } else {
            
            let alertMessage = UIAlertController(title: "Add Expense", message: "please fill the empty fields", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    
    
    
    /// This method is used to save the updated or newly entered context to the coredata stack
    func saveItems() {
        do {
            try AppConstants.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    
    /// This method is to open the `ExpenseCategoryViewController` with its delegate as current viewcontroller to retrive the selected category information
    func openExpenseCategory() {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.Segue.Identifier.ExpenseCategoryViewController) as? ExpenseCategoryViewController
        secondVC?.categoryViewModel.delegate = self
        self.present(secondVC!, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Notification
    
    /// This method helps to add the observers to the Keyboard notification
    func registerForKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// This method helps to remove the observers to the Keyboard notification
    func deregisterFromKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    /// This delegate method is used to showthe kewboard to uiview visibily in front of all the subviews
    ///
    /// - Parameter notification: notification is triggered
    @objc func keyboardWasShown(notification: NSNotification)
    {
        self.scrollView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if newExpenseViewModel.activeField != nil
        {
            if (!aRect.contains(newExpenseViewModel.activeField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(newExpenseViewModel.activeField!.frame, animated: true)
            }
        }
        
        
    }
    
   
    /// This delegate used to hide the keyboard from the view when the NSNotification is posted
    ///
    /// - Parameter notification: notification is triggered
    @objc func keyboardWillBeHidden(notification: NSNotification)
    {
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        
    }
    // MARK: - Picker Action
    
    /// open a currency picker custom alert view which hels to update the currencySymbol , currencyCode in currency button
    func currencyPickerOpen() {
        
        let alert = UIAlertController(title: "Currencies", message: "", preferredStyle: .alert
        )
        
        
        alert.addLocalePicker(type: .currency) { info in
            alert.title = info?.currencyCode
            alert.message = "is selected"
            self.newExpenseViewModel.currencySymbol = (info?.currencySymbol)!
            self.newExpenseViewModel.currencyCode = (info?.currencyCode)!
            self.currency.setTitle(info?.currencyCode, for: .normal)
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Creates the datepicker view, and animate opening the view
    func datePickerTapped() {
        
        let datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: .gray,
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        
        
        datePicker.show("ExpenseDatePicker",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: nil,
                        maximumDate: NSDate() as Date,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "MM/dd/yyyy"
                                self.date.text = formatter.string(from: dt)
                                
                            }
                            
        }
        
    }
    /// Create the timepicker view, and animate opening the view

    func timePickerTapped() {
        
        let datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: .gray,
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        
        datePicker.show("ExpenseTimePicker",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: nil,
                        maximumDate: NSDate() as Date,
                        datePickerMode: .time) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "HH:mm:ss a"
                                self.time.text = formatter.string(from: dt)
                            }
                            
        }
        
    }


 
 
    
}

