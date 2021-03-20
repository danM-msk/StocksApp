//
//  ViewController.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 09.03.2021.
//

import UIKit

class TrendingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let provider = FHProvider.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadData()
    }
    
//    func didUpdateTableView() -> Bool {
//        DispatchQueue.main.async {
//
//        } return
//    }

    var dowJonesCompanyProfiles: [FHCompany] = []
    
    func loadData() {
            provider.fetchCompany(with: DowJonesTickers[0]) { (companyResult, error) in
            if error != nil {
                print("error while fetching results")
            }
            guard let results = companyResult else { return }
            self.dowJonesCompanyProfiles.append(results)
        }
    }
    
}

extension TrendingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DowJonesTickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        guard let stockCell = cell as? StockCell else { return cell }
        stockCell.ticker.text = "\(DowJonesTickers[indexPath.row])"
        stockCell.companyName.text = "Apple Inc"
//        let stock = model.companies[indexPath.row]
//        if stock != nil {
//            stockCell.companyName.text = "\(model.companies[indexPath.row].name)"
//        }
        return cell
    }
}

extension TrendingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
