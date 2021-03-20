//
//  SearchViewController.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 20.03.2021.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let model = StockModel.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        model.fetchSupportedStocks {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.becomeFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.availableCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = self.tableView?.dequeueReusableCell(withIdentifier: K.searchedStockCell)
        if cell == nil
        {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: K.searchedStockCell)
        }
        
        cell!.textLabel?.text = model.availableCompanies[indexPath.row].ticker
        cell!.detailTextLabel?.text = model.availableCompanies[indexPath.row].title
        return cell!
    }
}
