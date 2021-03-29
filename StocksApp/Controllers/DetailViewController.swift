//
//  DetailViewController.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 22.03.2021.
//

import UIKit
import Charts

class DetailViewController: UIViewController {
    
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!
    
    let model = StockModel.instance
    let chartController = ChartDelegate()
    var loadedStockItem: StockItem?
    var addToFavouritesButtonIsSelected = false
    var completionHandler: (() -> Void)?
    
    func setupLineChartView() {
        let lineChartView = chartController.lineChartView
        view.addSubview(lineChartView)
        lineChartView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width)
        lineChartView.center = view.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLineChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.loadDetails { stockItem, error in
            if error != nil {
                self.showAlert(with: "Data loading error", message: error!.localizedDescription)
                return
            }
            guard let stockItem = stockItem, stockItem.ticker != nil else {
                self.showAlert(with: "Data error", message: "Incorrect API response")
                return
            }
            if let existingItem = self.model.companyItems.select(by: stockItem.ticker) {
                existingItem.updateDetails(from: stockItem)
                self.updateUI(existingItem)
            } else {
                self.updateUI(stockItem)
            }
        }
        chartController.loadData(with: .day)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        model.selectedTicker = nil
        if completionHandler != nil { completionHandler!() }
    }
    
    func updateUI(_ item: StockItem) {
        loadedStockItem = item
        DispatchQueue.main.async {
            self.logoImage.load(urlString: item.logoUrl!)
            self.companyName.text = item.companyName
            self.marketCapLabel.text = "$" + String(format: "%.2f", item.marketCapitalization!)
            self.industryLabel.text = String(item.finnhubindustry!)
            self.priceLabel.text = "$\(Double(item.currentPrice))"
            if item.priceChange > 0 {
                self.priceChangeLabel.text = "+" + String(format: "%.2f", item.priceChangePercentage!) + "%" + "|" + "$" + String(format: "%.2f", abs(item.priceChange!))
                self.priceChangeLabel.textColor = UIColor.systemGreen
            } else {
                self.priceChangeLabel.text = String(format: "%.2f", item.priceChangePercentage!) + "%" + " | " + "$" + String(format: "%.2f", abs(item.priceChange!))
                self.priceChangeLabel.textColor = UIColor.systemRed
            }
            self.addToFavouritesButtonIsSelected = item.isFavourite
            self.reloadFavouritesButtonImage()
        }
    }
    
    @IBAction func chartSegmentDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            chartController.loadData(with: .day)
        case 1:
            chartController.loadData(with: .week)
        case 2:
            chartController.loadData(with: .month)
        default:
            chartController.loadData(with: .day)
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favouritesButtonDidTap(_ sender: UIButton) {
        addToFavouritesButtonIsSelected = !addToFavouritesButtonIsSelected
        reloadFavouritesButtonImage()
        
        if let existingItem = model.companyItems.select(by: model.selectedTicker!) {
            existingItem.isFavourite = addToFavouritesButtonIsSelected
        } else if addToFavouritesButtonIsSelected == true && loadedStockItem != nil {
            loadedStockItem!.isFavourite = addToFavouritesButtonIsSelected
            model.companyItems.append(loadedStockItem!)
            model.defaultTickers.append(loadedStockItem!.ticker)
        }
    }
    
    func reloadFavouritesButtonImage() {
        addToFavouritesButtonIsSelected
            ? favouritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            : favouritesButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
}

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func load(urlString: String) {
        
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self?.image = image
                    }
                }
            }
        }
}
}
