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
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupTableView()
        refresh(sender: self)
    }
    
    private func setupHeader() {
        navigationBarView.layer.cornerRadius = 10
        trendingButton.layer.cornerRadius = 16
        favouritesButton.layer.cornerRadius = 16
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
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
    
    @objc func refresh(sender:AnyObject) {
        self.refreshControl.beginRefreshing()
        model.loadStocks { error in
            if error != nil {
                self.showAlert(with: "Data loading error", message: error!.localizedDescription)
                DispatchQueue.main.async { self.refreshControl.endRefreshing() }
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.toDetailFromMain {
            let vc = segue.destination as! DetailViewController
            vc.completionHandler = {
                self.model.companyItems = self.model.companyItems.sorted(by: { $0.ticker! < $1.ticker! })
                self.tableView.reloadData() }
        } else if segue.identifier == K.toSearchFromMain {
            let vc = segue.destination as! SearchViewController
            vc.completionHandler = {
                if self.model.selectedTicker != nil {
                    self.performSegue(withIdentifier: K.toDetailFromMain, sender: self)
                }
            }
            
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
        if isFavoritesModeEnabled == false {
            if let selectedTicker = model.companyItems[indexPath.row].ticker {
                model.selectedTicker = selectedTicker
            }
        } else {
            if let selectedTicker = model.companyItems.favourites[indexPath.row].ticker {
                model.selectedTicker = selectedTicker
            }
        }
        performSegue(withIdentifier: K.toDetailFromMain, sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFavoritesModeEnabled ? model.companyItems.favourites.count : model.companyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier) as! StockCell
        let item = isFavoritesModeEnabled ? model.companyItems.favourites[indexPath.row] : model.companyItems[indexPath.row]
        cell.companyName?.text = item.companyName
        cell.ticker?.text = item.ticker
        cell.price?.text = "$" + String(format: "%.2f", item.currentPrice!)
        if item.priceChange > 0 {
            cell.priceChange?.text = "+" + String(format: "%.2f", item.priceChangePercentage!) + "%"
        } else {
            cell.priceChange?.text = String(format: "%.2f", item.priceChangePercentage!) + "%"
        }
        cell.priceChange?.textColor = dynamicColorFor(item.priceChange!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFavoritesModeEnabled {
                let tickerToDelete = model.companyItems.favourites[indexPath.row].ticker!
                let defaultTickersIndex = model.defaultTickers.firstIndex(of: tickerToDelete)!
                model.defaultTickers.remove(at: defaultTickersIndex)
                let companyItemsIndex = model.companyItems.firstIndex { $0.ticker == tickerToDelete }!
                model.companyItems.remove(at: companyItemsIndex)
            } else {
                let tickerToDelete = model.companyItems[indexPath.row].ticker!
                let index = model.defaultTickers.firstIndex(of: tickerToDelete)!
                model.defaultTickers.remove(at: index)
                model.companyItems.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
