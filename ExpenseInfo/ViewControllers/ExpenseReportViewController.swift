

import UIKit
import CoreData
import RKPieChart


// MARK: - UITableViewDelegate
extension ExpenseReportViewController: UITableViewDelegate {
    /// Asks the data source for a cell to insert in a particular location of the table view.
    ///
    /// - Parameters:
    ///   - tableView: A table-view object requesting the cell.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: An object inheriting from UITableViewCell that the table view can use for the specified row. UIKit raises an assertion if you return nil.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "reportCell")! as! ReportsTableViewCell
        let myItem = reportItemsArray[indexPath.row]
        print(myItem)
        cell.colorImg.backgroundColor = myItem.color
        cell.typeLbl.text = myItem.type
        let valuePercent = String(format:"%.2f", myItem.percentage!)
        cell.percentage.text = "\(valuePercent)%"
        let value = String(format:"%.2f", myItem.amount!)
        cell.amount.text = "\(globalCurrencySymbol)\(value)"
        
        return cell
    }
}

// MARK: - UITableViewDataSource
extension ExpenseReportViewController: UITableViewDataSource {
    /// Tells the data source to return the number of rows in a given section of a table view.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - section: An index number identifying a section in tableView.
    /// - Returns: The number of rows in section.

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportItemsArray.count
    }
    
    /// Asks the data source to return the number of sections in the table view.
    ///
    /// - Parameter tableView: An object representing the table view requesting this information.
    /// - Returns: The number of sections in tableView.

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
/// Generates Expense Report and display it in a Pie chart
class ExpenseReportViewController: UIViewController {
    
    /// expenseTable presents data using rows arranged in a single column.
    @IBOutlet weak var expenseTable: UITableView!
    
    /// viewsize object that manages the content for a rectangular area on the screen.
    @IBOutlet weak var viewsize: UIView!
    
    /// midview object that manages the content for a rectangular area on the screen.
    @IBOutlet weak var midview: UIView!
    
    /// emptyImageBox displays a single image or a sequence of animated images in your interface.
    @IBOutlet weak var emptyImageBox: UIImageView!
    
    /// scrollView that allows the scrolling and zooming of its contained views.
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// expenseValueBlock a double-precision, floating-point value type.
    var expenseValueBlock : Double = 0.0
    
    /// Default global currency symbol
    var globalCurrencySymbol : String = "$"

    /// array of ReportItemViewModel
    var reportItemsArray = [ReportItemViewModel]()
    /// Called after the controller's view is loaded into memory.

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.CurrencyCode) != nil {
            if let currencySymbol = UserDefaults.standard.value(forKey: AppConstants.Defaults.Key.CurrencySymbol) {
                globalCurrencySymbol = "\(currencySymbol)"
            } else {
                globalCurrencySymbol = "$"
            }
        }
        updateExpenseBlocks()
        
    }
    

    
    /// Indicates the Empty text in the Label
    @IBOutlet weak var emptyLbl: UILabel!
    

    
    /// This method Updates the PieChart for the Expense by fetching the data from the core data model
    func updateExpenseBlocks() {
        var itemsArray = [RKPieChartItem]()
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        
        do {
            let fetchedtype = try AppConstants.managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            if fetchedtype.count > 0 {
                fetchedtype.forEach { (exp) in
                    let myString = exp.amount
                    let myFloat = (myString! as NSString).doubleValue
                    expenseValueBlock += myFloat

                }
            }
        } catch {
            
        }
        
        
        
        
        let catId : [String] = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17"]
        var categorycolor : String = ""
        
        
        catId.forEach { (i) in
            let typefetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
            typefetch1.predicate = NSPredicate(format: "categoryId == %@ ",i)
            
            do {
                let fetchedtype = try AppConstants.managedObjectContext.fetch(typefetch1) as! [ExpenseContent]
                if fetchedtype.count > 0 {
                    var expenseAmount : Double = 0.0
                    var categoryName : String = ""

                    fetchedtype.forEach({ (exp) in
                        expenseAmount += Double(exp.amount!)!
                        categorycolor = exp.categoryColor!
                        categoryName = exp.expenseCategory!
                    })
                    let a : Double = expenseAmount
                    let b : Double = expenseValueBlock
                    let c = (a / b ) * 100
                    let item1 =  ReportItemViewModel(color: UIColor(hexString: categorycolor), type: categoryName, percentage:c , amount: expenseAmount)
                    
                    reportItemsArray.append(item1)
                    
                    let firstItem: RKPieChartItem = RKPieChartItem(ratio: uint(c), color: UIColor(hexString: categorycolor), title: "")
                    itemsArray.append(firstItem)
                } else {
                    
                }
                
                
                
            } catch {
                print(error)
            }
        }
        let value = String(format:"%.2f", expenseValueBlock)
        let title = "\(globalCurrencySymbol)\(value)"
        let chartView = RKPieChartView(items: itemsArray, centerTitle: title)


        chartView.circleColor = itemsArray.count == 1 ? UIColor(hexString: categorycolor) : .clear
        
        emptyImageBox.isHidden = itemsArray.count == 0 ? false : true
        self.expenseTable.isHidden = itemsArray.count == 0 ? true : false
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.arcWidth = 50
        chartView.isIntensityActivated = false
        chartView.style = .butt
        chartView.isTitleViewHidden = true
        chartView.isAnimationActivated = true
        self.viewsize.addSubview(chartView)
        chartView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        chartView.centerXAnchor.constraint(equalTo: self.viewsize.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: self.viewsize.centerYAnchor).isActive = true
        
        
        
    }
    
    
}
