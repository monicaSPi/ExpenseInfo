import UIKit


/// Customized Picker View Controller
final class LocalePickerViewController: UIViewController {
    
    // MARK: Properties
    
    /// typealiasing (LocaleInfo?) -> Swift.Void
    public typealias Selection = (LocaleInfo?) -> Swift.Void
    /// Result enum
    ///
    /// - country: returns country
    /// - currency: returns currency
    /// - store: returns store
    public enum Kind {
        case country
        case currency
        case store
    }
    
    /// type Kind of Picker
    fileprivate var type: Kind
    
    /// selection
    fileprivate var selection: Selection?
    
    /// Ordered Information of the Locale
    fileprivate var orderedInfo = [String: [LocaleInfo]]()
    
    /// String Obejct Array of the Locale
    fileprivate var sortedInfoKeys = [String]()
    
    /// Array Instance of LocaleInfo
    fileprivate var filteredInfo: [LocaleInfo] = []
    
    /// Instance of LocaleInfo
    fileprivate var selectedInfo: LocaleInfo?
    
    /// searchView
    fileprivate lazy var searchView: UIView = UIView()
    
    /// seacrchController Initialization
    fileprivate lazy var searchController: UISearchController = { [unowned self] in
        $0.searchResultsUpdater = self
        $0.searchBar.delegate = self
        $0.dimsBackgroundDuringPresentation = false
        /// true if search bar in tableView header
        $0.hidesNavigationBarDuringPresentation = true
        $0.searchBar.searchBarStyle = .minimal
        var textFieldInsideSearchBar = $0.searchBar.value(forKey: AppConstants.Defaults.Key.searchField) as? UITextField
        textFieldInsideSearchBar?.textColor = .black
        textFieldInsideSearchBar?.clearButtonMode = .whileEditing
        return $0
        }(UISearchController(searchResultsController: nil))
    
    /// tableView Initialization
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = UI.rowHeight
        $0.separatorColor = UI.separatorColor
        $0.bounces = true
        $0.backgroundColor = nil
        $0.tableFooterView = UIView()
        $0.sectionIndexBackgroundColor = .clear
        $0.sectionIndexTrackingBackgroundColor = .clear
        return $0
        }(UITableView(frame: .zero, style: .plain))
    
    /// Activity Indicator View Initialization
    fileprivate lazy var indicatorView: UIActivityIndicatorView = {
        $0.color = .lightGray
        return $0
    }(UIActivityIndicatorView(style: .whiteLarge))
    
    // MARK: Initialize
    
    /// Initializing the Kind of Picker and the Selection made
    ///
    /// - Parameters:
    ///   - type: Kind of Picker
    ///   - selection: Locale Selection
    required init(type: Kind, selection: @escaping Selection) {
        self.type = type
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    /// Returns an object initialized from data in a given unarchiver.
    ///
    /// - Parameter aDecoder: An unarchiver object.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // http://stackoverflow.com/questions/32675001/uisearchcontroller-warning-attempting-to-load-the-view-of-a-view-controller/
        let _ = searchController.view
        //        Log("has deinitialized")
    }
    
    /// Creates the view that the controller manages.
    override func loadView() {
        view = tableView
    }
    /// Called after the controller's view is loaded into memory.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(indicatorView)
        
        searchView.addSubview(searchController.searchBar)
        tableView.tableHeaderView = searchView
        
        //extendedLayoutIncludesOpaqueBars = true
        //edgesForExtendedLayout = .bottom
        definesPresentationContext = true
        
        switch type {
        case .country:
            tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.identifier)
        case .store:
            tableView.register(StoreTableViewCell.self, forCellReuseIdentifier: StoreTableViewCell.identifier)
        case .currency:
            tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.identifier)
        }
        
        updateInfo()
    }
    
    
    /// Called to notify the view controller that its view is about to layout its subviews.
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.tableHeaderView?.height = 57
        searchController.searchBar.sizeToFit()
        searchController.searchBar.frame.size.width = searchView.frame.size.width
        searchController.searchBar.frame.size.height = searchView.frame.size.height
    }
    /// Called to notify the view controller that its view has just laid out its subviews.
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        indicatorView.center = view.center
        preferredContentSize.height = tableView.contentSize.height
    }
    
    /// This method fetch the data from the LocaleStore
    func updateInfo() {
        indicatorView.startAnimating()
        
        LocaleStore.fetch { [unowned self] result in
            switch result {
                
            case .success(let orderedInfo):
                let data: [String: [LocaleInfo]] = orderedInfo
                
                
                self.orderedInfo = data
                self.sortedInfoKeys = Array(self.orderedInfo.keys).sorted(by: <)
                
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                    self.tableView.reloadData()
                }
                
            case .error(let error):
                
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
                    alert.addAction(title: "OK", style: .cancel) { action in
                        self.indicatorView.stopAnimating()
                        self.alertController?.dismiss(animated: true)
                    }
                    alert.show()
                }
            }
        }
    }
    
    /// sort the FilteredInfo with type as condition
    func sortFilteredInfo() {
        filteredInfo = filteredInfo.sorted { lhs, rhs in
            switch type {
            case .country:
                return lhs.country < rhs.country
            case .store:
                return lhs.country < rhs.country
            case .currency:
                return lhs.country < rhs.country
            }
        }
    }
    
    /// Get the information from the orderedInfo
    ///
    /// - Parameter indexPath: indexPath has row and section
    /// - Returns: return LocaleInfo
    func info(at indexPath: IndexPath) -> LocaleInfo? {
        if searchController.isActive {
            return filteredInfo[indexPath.row]
        }
        let key: String = sortedInfoKeys[indexPath.section]
        if let info = orderedInfo[key]?[indexPath.row] {
            return info
        }
        return nil
    }
    
    /// Gives the indexPather of the selected Information
    ///
    /// - Returns: return the IndexPath value with row and section
    func indexPathOfSelectedInfo() -> IndexPath? {
        guard let selectedInfo = selectedInfo else { return nil }
        if searchController.isActive {
            for row in 0 ..< filteredInfo.count {
                if filteredInfo[row].country == selectedInfo.country {
                    return IndexPath(row: row, section: 0)
                }
            }
        }
        for section in 0 ..< sortedInfoKeys.count {
            if let orderedInfo = orderedInfo[sortedInfoKeys[section]] {
                for row in 0 ..< orderedInfo.count {
                    if orderedInfo[row].country == selectedInfo.country {
                        return IndexPath(row: row, section: section)
                    }
                }
            }
        }
        return nil
    }
}


// MARK: - UISearchResultsUpdating
extension LocalePickerViewController: UISearchResultsUpdating {
    
    /// Called when the search bar becomes the first responder or when the user makes changes inside the search bar.
    ///
    /// - Parameter searchController: The `UISearchController` object used as the search bar.
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchController.isActive {
            filteredInfo = []
            if searchText.count > 0, let values = orderedInfo[String(searchText[searchText.startIndex])] {
                filteredInfo.append(contentsOf: values.filter { $0.country.hasPrefix(searchText) })
            } else {
                orderedInfo.forEach { key, value in
                    filteredInfo += value
                }
            }
            sortFilteredInfo()
        }
        tableView.reloadData()
        
        guard let selectedIndexPath = indexPathOfSelectedInfo() else { return }
        //        Log("selectedIndexPath = \(selectedIndexPath)")
        tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
    }
}

// MARK: - UISearchBarDelegate

extension LocalePickerViewController: UISearchBarDelegate {
    
    /// ells the delegate that the cancel button was tapped.
    ///
    /// - Parameter searchBar: The search bar that was tapped.
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

// MARK: - TableViewDelegate

extension LocalePickerViewController: UITableViewDelegate {
    
    /// Tells the delegate that the specified row is now selected.
    ///
    /// - Parameters:
    ///   - tableView: A table-view object informing the delegate about the new row selection.
    ///   - indexPath: An index path locating the new selected row in tableView.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let info = info(at: indexPath) else { return }
        selectedInfo = info
        selection?(selectedInfo)
    }
}

// MARK: - TableViewDataSource

extension LocalePickerViewController: UITableViewDataSource {
    
    /// Asks the data source to return the number of sections in the table view.
    ///
    /// - Parameter tableView: An object representing the table view requesting this information.
    /// - Returns: The number of sections in tableView.
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive { return 1 }
        return sortedInfoKeys.count
    }
    
    /// Tells the data source to return the number of rows in a given section of a table view.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - section: An index number identifying a section in tableView.
    /// - Returns: The number of rows in section.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive { return filteredInfo.count }
        if let infoForSection = orderedInfo[sortedInfoKeys[section]] {
            return infoForSection.count
        }
        return 0
    }
    
    /// Asks the data source to return the index of the section having the given title and section title index.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - title: The title as displayed in the section index of tableView.
    ///   - index: n index number identifying a section title in the array returned by `sectionIndexTitles(for:)`.
    /// - Returns: An index number identifying a section.
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if searchController.isActive { return 0 }
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top , animated: false)
        return sortedInfoKeys.firstIndex(of: title)!
    }
    
    /// Asks the data source to return the titles for the sections of a table view.
    ///
    /// - Parameter tableView: The table-view object requesting this information.
    
    /// - Returns: An array of strings that serve as the title of sections in the table view and appear in the index list on the right side of the table view. The table view must be in the plain style (UITableViewStylePlain). For example, for an alphabetized list, you could return an array containing strings “A” through “Z”.
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive { return nil }
        return sortedInfoKeys
    }
    
    /// Asks the data source for the title of the header of the specified section of the table view.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object asking for the title.
    ///   - section: An index number identifying a section of tableView .
    /// - Returns: A string to use as the title of the section header. If you return nil , the section will have no title.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive { return nil }
        return sortedInfoKeys[section]
    }
    
    /// Asks the data source for a cell to insert in a particular location of the table view.
    ///
    /// - Parameters:
    ///   - tableView: A table-view object requesting the cell.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: An object inheriting from UITableViewCell that the table view can use for the specified row. UIKit raises an assertion if you return nil.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let info = info(at: indexPath) else { return UITableViewCell() }
        
        let cell: UITableViewCell
        
        switch type {
            
        case .country:
            cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier) as! CountryTableViewCell
            cell.textLabel?.text = info.country
        case .store:
            cell = tableView.dequeueReusableCell(withIdentifier: StoreTableViewCell.identifier) as! StoreTableViewCell
            cell.textLabel?.text = info.country
        case .currency:
            cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.identifier) as! CurrencyTableViewCell
            cell.textLabel?.text = info.currencyCode
            cell.detailTextLabel?.text = info.country
        }
        
        cell.detailTextLabel?.textColor = .darkGray
        
        DispatchQueue.main.async {
            let size: CGSize = CGSize(width: 32, height: 24)
            let flag: UIImage? = info.flag?.imageWithSize(size: size, roundedRadius: 3)
            cell.imageView?.image = flag
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        if let selected = selectedInfo, selected.country == info.country {
            cell.isSelected = true
        }
        
        return cell
    }
}
