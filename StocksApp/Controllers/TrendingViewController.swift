//
//  ViewController.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 09.03.2021.
//

import UIKit

class TrendingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let model = StockModel.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        model.loadCompanies {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func dynamicColorFor(_ price: Double) -> UIColor {
        if price > 0 {
            return .green
        } else if price < 0 {
            return .red
        } else {
            return .gray
        }
    }
}

extension TrendingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let selectedStock = model.companyItems[indexPath!.row].ticker
        performSegue(withIdentifier: K.trendingToDetailSegueIdentifier, sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.companyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier) as! StockCell
        let item = model.companyItems[indexPath.row]
        cell.companyName?.text = item.companyName
        cell.ticker?.text = item.ticker
        cell.price?.text = String(format: "%.2f", item.currentPrice!)
        cell.priceChange?.text = String(format: "%.2f", item.priceChange!)
        cell.priceChange?.textColor = dynamicColorFor(item.priceChange!)
        return cell;
    }
}
