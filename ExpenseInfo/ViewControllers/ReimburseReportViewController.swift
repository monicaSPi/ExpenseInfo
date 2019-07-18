

import UIKit
import CoreData
import RKPieChart

// MARK: - Double
extension Double {
    
    /// String with Format function
    ///
    /// - Parameter f: f as a string
    /// - Returns: returns formatted string
    func format(f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}

/// Generates Reimbursement Report and display it in a Pie chart
class ReimburseReportViewController: UIViewController{
    
    /// expenseTable presents data using rows arranged in a single column.
    @IBOutlet weak var expenseTable: UITableView!
    
    /// viewsize object that manages the content for a rectangular area on the screen.
    @IBOutlet weak var viewsize: UIView!
    
    /// emptyImageBox displays a single image or a sequence of animated images in your interface.
    @IBOutlet weak var emptyImageBox: UIImageView!
    
    /// midview object that manages the content for a rectangular area on the screen.
    @IBOutlet weak var midview: UIView!
    
    /// Indicates the Empty text in the Label
    @IBOutlet weak var emptyLbl: UILabel!
    
    /// A view that allows the scrolling and zooming of its contained views.
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            self.scrollView.isScrollEnabled = true
            let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    
    
    
    /// expenseValueBlock a double-precision, floating-point value type.
    var expenseValueBlock : Double = 0.0
    
    /// claimedValueBlock a double-precision, floating-point value type.
    var claimedValueBlock : Double = 0.0
    
    /// unclaimedValueBlock a double-precision, floating-point value type.
    var unclaimedValueBlock : Double = 0.0
    
    /// Array of ReportItemViewModel
    var reportItemsArray = Array<ReportItemViewModel>()//[ReportItemViewModel]()
    
    /// Static Category Array
    var categNameArray : [String] = ["Cloths","Food","Health", "Hotel","Party","Travel", "Education" , "Entertainment" , "Fitness","Gift","Labour","Loan","Shop","Sports","Transport","Utilities","Others"]
    
    
    
    /// Called for fetching the claimed and unclaimed list from the core data entitiy `ExpenseContent`
    func getClaimedandUnclaimedList() {
        
        var claim : Int = 0
        var unclaim : Int = 0
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch.predicate = NSPredicate(format: "isClaimed == %@ ","CL")
        
        do {
            let fetchedtype = try AppConstants.managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            
            if fetchedtype.count > 0 {
     
                fetchedtype.forEach { (exp) in
                    let myString = exp.amount
                    let myFloat = (myString! as NSString).doubleValue
                    
                    claimedValueBlock += myFloat
                }
                claim = 1
            }
        } catch {
            
            
        }
        
        
        let typefetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch1.predicate = NSPredicate(format: "isClaimed == %@ ","NC")
        
        do {
            let fetchedtype1 = try AppConstants.managedObjectContext.fetch(typefetch1) as! [ExpenseContent]
            
            if fetchedtype1.count > 0 {
                
                fetchedtype1.forEach { (exp) in
                    
                    let myString = exp.amount
                    let myFloat = (myString! as NSString).doubleValue
                    
                    unclaimedValueBlock += myFloat
                }
                unclaim = 1
            } else {
                
            }
        } catch {
            
            
        }
        if claim == 0 && unclaim == 0 {
            emptyImageBox.isHidden = false
            reportItemsArray = [ReportItemViewModel]()
            expenseTable.reloadData()
        } else {
            updateChart()
            emptyImageBox.isHidden = true
        }
        
    }
    
    /// This method perform Math / Arithmetic Calculation to find the percentage of the reimbursement made based on claimed and unclaimed value
    func updateChart() {
        let reimbursable: Double = claimedValueBlock + unclaimedValueBlock
        
        let currencyDouble: Double = reimbursable  //100.0
        
        let totalCreditCounter: Double = claimedValueBlock
        let totalSpending: Double = unclaimedValueBlock
        
        let spendperCent = 100*totalSpending / currencyDouble
        let balanceperCent = 100*(totalCreditCounter - totalSpending) / currencyDouble
        let spentperCentCGFloat =  spendperCent
        var balanceperCentCGFloat = balanceperCent
        
        print("Percentage ================= >\(spentperCentCGFloat)")
        
        if spentperCentCGFloat < 1 {
        }
        if abs(balanceperCentCGFloat) == abs(spentperCentCGFloat) {
            balanceperCentCGFloat = 0.0
        }
        
        let item1 =  ReportItemViewModel(color: UIColor(hexString: "6DC0DD"), type: "Claimed", percentage: abs(balanceperCentCGFloat), amount: claimedValueBlock)
        let item2 =  ReportItemViewModel(color: UIColor(hexString: "6BC284"), type: "Unclaimed", percentage: abs(spentperCentCGFloat), amount: unclaimedValueBlock)
        
        reportItemsArray.append(item1)
        reportItemsArray.append(item2)
        self.expenseTable.reloadData()
        balanceperCentCGFloat = abs(balanceperCentCGFloat)
        
        var itemsArray = [RKPieChartItem]()
        
        let firstItem: RKPieChartItem = RKPieChartItem(ratio: uint(balanceperCentCGFloat), color: UIColor(hexString: "6DC0DD"), title: "")
        let secondItem: RKPieChartItem = RKPieChartItem(ratio: uint(abs(spentperCentCGFloat)), color: UIColor(hexString: "6BC284"), title: "")
        
        let value = String(format:"%.2f", reimbursable)
        if spentperCentCGFloat < 1 {
        }
        if balanceperCentCGFloat == 0 {
            balanceperCentCGFloat = 1
            let zeroItem: RKPieChartItem = RKPieChartItem(ratio: uint(balanceperCentCGFloat), color: UIColor(hexString: "6BC284"), title: "")
            itemsArray.append(zeroItem)
            itemsArray.append(secondItem)
        } else {
            if spentperCentCGFloat == 0 {
                let zeroItem: RKPieChartItem = RKPieChartItem(ratio: uint(balanceperCentCGFloat), color: UIColor(hexString: "6DC0DD"), title: "")
                itemsArray.append(firstItem)
                itemsArray.append(zeroItem)
            } else {
                itemsArray.append(firstItem)
                itemsArray.append(secondItem)
            }
        }
        let title = "\(globalCurrencySymbol)\(value)"
        let chartView = RKPieChartView(items: itemsArray, centerTitle: title)
        chartView.circleColor = .clear
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
    
    /// Default global currency symbol
    var globalCurrencySymbol : String = "$"
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
        
        getClaimedandUnclaimedList()
        
    }
    
}

// MARK: - UITableViewDataSource
extension ReimburseReportViewController: UITableViewDataSource {
    
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
