//
//  ViewController.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 09.03.2021.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var trendingButton: UIButton!
    @IBOutlet weak var navigationBarView: UIView!
    let model = StockModel.instance
    var isFavoritesModeEnabled = false
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarView.layer.cornerRadius = 10
        trendingButton.layer.cornerRadius = 16
        favouritesButton.layer.cornerRadius = 16
        
        setupTableView()
        model.loadCompaniesInfoAndPrice {
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
            return .systemGreen
        } else if price < 0 {
            return .systemRed
        } else {
            return .systemGray
        }
    }
    
    @IBAction func favouritesButtonDidTap(_ sender: UIButton) {
        isFavoritesModeEnabled = true
        favouritesButton.backgroundColor = UIColor(named: "ActiveButtonBackground")
        favouritesButton.setTitleColor(UIColor(named: "ActiveButtonText"), for: .normal)
        trendingButton.backgroundColor = UIColor(named: "NonActiveButtonBackground")
        trendingButton.setTitleColor(UIColor(named: "NonActiveButtonText"), for: .normal)
        self.tableView.reloadData()
    }
    
    @IBAction func trendingButtonDidTap(_ sender: UIButton) {
        isFavoritesModeEnabled = false
        trendingButton.backgroundColor = UIColor(named: "ActiveButtonBackground")
        trendingButton.setTitleColor(UIColor(named: "ActiveButtonText"), for: .normal)
        favouritesButton.backgroundColor = UIColor(named: "NonActiveButtonBackground")
        favouritesButton.setTitleColor(UIColor(named: "NonActiveButtonText"), for: .normal)
        self.tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let selectedTicker = model.companyItems[indexPath!.row].ticker
        model.selectedTicker = selectedTicker
        performSegue(withIdentifier: K.fromTrendingSegueID, sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFavoritesModeEnabled ? model.favouriteTickers.count : model.companyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier) as! StockCell
        let item = isFavoritesModeEnabled ? model.favouriteTickers[indexPath.row] : model.companyItems[indexPath.row]
        cell.companyName?.text = item.companyName
        cell.ticker?.text = item.ticker
        cell.price?.text = "$" + String(format: "%.2f", item.currentPrice!)
        if item.priceChange > 0 {
            cell.priceChange?.text = "+" + String(format: "%.2f", item.priceChange!) + "%"
        } else {
            cell.priceChange?.text = String(format: "%.2f", item.priceChange!) + "%"
        }
        cell.priceChange?.textColor = dynamicColorFor(item.priceChange!)
        return cell;
    }
}