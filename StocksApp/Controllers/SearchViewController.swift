//
//  SearchViewController.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 20.03.2021.
//

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCompanies: [FHStock] = []
    let model = StockModel.instance
    var isSearchBarEmpty: Bool { return searchController.searchBar.text?.isEmpty ?? true }
    var isFiltering: Bool { return searchController.isActive && !isSearchBarEmpty }
    var completionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        model.loadSupportedStocks { error in
            if error != nil {
                self.showAlert(with: "Data loading error", message: error!.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateSearchResults(for: self.searchController)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchController.isActive = true
        self.searchController.searchBar.becomeFirstResponder()
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
        searchController.searchBar.placeholder = "Search all US stocks by ticker or name"
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if completionHandler != nil { completionHandler!() }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tickerFromSelectedCell = isFiltering
            ? filteredCompanies[indexPath.row].ticker
            : model.availableCompanies[indexPath.row].ticker
        if let selectedTicker =  tickerFromSelectedCell {
            model.selectedTicker = selectedTicker
        }
        self.searchController.isActive = false
        dismiss(animated: true, completion: nil)
    }
    
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
    private func filterContentForSearchText(_ searchText: String) {
        filteredCompanies = model.availableCompanies.filter { (type: FHStock) -> Bool in
            return type.title!.lowercased().contains(searchText.lowercased())
                || type.ticker!.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}
