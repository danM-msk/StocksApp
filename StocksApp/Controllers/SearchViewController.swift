//
//  SearchViewController.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 20.03.2021.
//

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    let model = StockModel.instance
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCompanies: [FHStock] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        model.fetchSupportedStocks {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        filterContentForSearchText(searchController.searchBar.text ?? "Search here")
        updateSearchResults(for: searchController)
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupSearchBar() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Stocks"
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchController.searchBar.becomeFirstResponder() // does not wotk
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCompanies = model.availableCompanies.filter { (type: FHStock) -> Bool in
            return type.title!.lowercased().contains(searchText.lowercased())
                || type.ticker!.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCompanies.count
        }
        
        return model.availableCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.searchedStockCell, for: indexPath)
        let type: FHStock
        if isFiltering {
            type = filteredCompanies[indexPath.row]
        } else {
            type = model.availableCompanies[indexPath.row]
        }
        cell.textLabel?.text = type.ticker
        cell.detailTextLabel?.text = type.title
        return cell
    }
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateSearchResults(for: searchController)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResults(for: searchController)
    }
}