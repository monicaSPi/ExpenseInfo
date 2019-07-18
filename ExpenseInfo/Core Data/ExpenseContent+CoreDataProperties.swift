
import Foundation
import CoreData

/// To create attributes and relationships for the entity
extension ExpenseContent {
    /// fetchRequest made to fetch NSManagedObject Instances for entity `ExpenseContent`
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseContent> {
        return NSFetchRequest<ExpenseContent>(entityName: "ExpenseContent")
    }
    /// `declare the properties using the @NSManaged keyword`
    
    /// Expense Amount
    @NSManaged public var amount: String?
    
    /// Expense Bill Image
    @NSManaged public var billImage: Data?
    
    /// Expense category color
    @NSManaged public var categoryColor: String?
    
    /// Expense category id
    @NSManaged public var categoryId: String?
    
    /// Expense currency code
    @NSManaged public var currencyCode: String?
    
    /// Expense date
    @NSManaged public var dateString: String?
    
    /// Expense Category
    @NSManaged public var expenseCategory: String?
    
    /// Expense Category Image
    @NSManaged public var expenseCategoryImg: Data?
    
    /// Expense Mode
    @NSManaged public var expenseMode: String?
    
    /// Expense Currency Symbol
    @NSManaged public var currencySymbolString: String?
    
    /// Expense id
    @NSManaged public var id: String?
    
    /// Expense is Claimed
    @NSManaged public var isClaimed: String?
    
    /// Merchant name
    @NSManaged public var merchantName: String?
    
    /// Expense month
    @NSManaged public var monthString: String?
    
    /// Expense notes
    @NSManaged public var notes: String?
    
    /// Expense reimbursable or not
    @NSManaged public var reimbursable: Bool
    
    /// Tags
    @NSManaged public var tags: NSObject?
    
    /// Expense time
    @NSManaged public var timeString: String?
    
    /// Expense year
    @NSManaged public var yearString: String?
    
}
