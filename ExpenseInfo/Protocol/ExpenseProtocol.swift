

import Foundation
/// A set of methods that your delegate object must implement to interact with the AddNewExpenseViewController
protocol CategoryInfoDelegate: class {
    
    /// Fetch the category information from the `ExpenseCategoryViewController` and set the delegate method to send the value to uiviewcontroller
    ///
    /// - Parameters:
    ///   - name: name of the category
    ///   - image: image of the category
    ///   - id: unique identifier of the category
    ///   - color: color of the category
    func categoryInformation(name: String, image: String, id: String , color: String)
}
