
import Foundation
import CoreData

/// To create attributes and relationships for the entity
extension ExpenseContent {
    /// fetchRequest made to fetch NSManagedObject Instances for entity `ExpenseContent`
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseContent> {
        return NSFetchRequest<ExpenseContent>(entityName: "ExpenseContent")
    }
    /// `declare the properties using the @NSManaged keyword`
    
    /// <#Description#>
    @NSManaged public var amount: String?
    
    /// <#Description#>
    @NSManaged public var billImage: Data?
    
    /// <#Description#>
    @NSManaged public var categoryColor: String?
    
    /// <#Description#>
    @NSManaged public var categoryId: String?
    
    /// <#Description#>
    @NSManaged public var currencyCode: String?
    
    /// <#Description#>
    @NSManaged public var dateString: String?
    
    /// <#Description#>
    @NSManaged public var expenseCategory: String?
    
    /// <#Description#>
    @NSManaged public var expenseCategoryImg: Data?
    
    /// <#Description#>
    @NSManaged public var expenseMode: String?
    
    /// <#Description#>
    @NSManaged public var currencySymbolString: String?
    
    /// <#Description#>
    @NSManaged public var id: String?
    
    /// <#Description#>
    @NSManaged public var isClaimed: String?
    
    /// <#Description#>
    @NSManaged public var merchantName: String?
    
    /// <#Description#>
    @NSManaged public var monthString: String?
    
    /// <#Description#>
    @NSManaged public var notes: String?
    
    /// <#Description#>
    @NSManaged public var reimbursable: Bool
    
    /// <#Description#>
    @NSManaged public var tags: NSObject?
    
    /// <#Description#>
    @NSManaged public var timeString: String?
    
    /// <#Description#>
    @NSManaged public var yearString: String?
    
}
