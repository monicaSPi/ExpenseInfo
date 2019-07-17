

import UIKit

/// <#Description#>
class ExpenseFilterViewController: UIViewController {
    
    // MARK: IBOutlet Properties
    @IBOutlet weak var merchantBtn: RoundButton!
    
    /// <#Description#>
    @IBOutlet weak var cuatomeDate: UITextField!
    
    /// <#Description#>
    @IBOutlet weak var calenderImg: UIImageView!
    
    /// <#Description#>
    @IBOutlet weak var categoryButton: RoundButton!
    
    // MARK: Default View Controller Methods
    /// Called after the controller's view is loaded into memory.

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBAction Methods
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func categorySelected(_ sender: UIButton) {
    }
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func merchantSelected(_ sender: UIButton) {
    }
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
