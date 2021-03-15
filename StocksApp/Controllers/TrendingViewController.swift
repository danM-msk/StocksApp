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
    
//    func didUpdateTableView() -> Bool {
//        DispatchQueue.main.async {
//
//        } return
//    }
    
}

extension TrendingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        guard let stockCell = cell as? StockCell else { return cell }
        stockCell.ticker.text = "AAPL"
        stockCell.companyName.text = "Apple Inc"
        let stock = model.companies[indexPath.row]
        if stock != nil {
            stockCell.companyName.text = "\(model.companies[indexPath.row].name)"
        }
        return cell
    }
}

extension TrendingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
