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
        model.loadData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
}

extension TrendingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! StockCell
        cell.ticker.text = "AAPL"
        cell.companyName.text = "Apple Inc"
        if let myStock = firstStock {
            cell.price.text = "\(myStock.c)"
            cell.priceChange.text = "\(myStock.c - myStock.o)"
        } else {
            cell.price.text = "\(popularStocks[indexPath.row].c)"
            cell.priceChange.text = "\(popularStocks[indexPath.row].o)"
        }
        return cell
    }
}

extension TrendingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

