//
//  DetailViewController.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 22.03.2021.
//

import UIKit
import Charts

class DetailViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var favouritesButton: UIButton!
    
    var addToFavouritesButtonIsSelected = false
    
    let model = StockModel.instance
    var values = [ChartDataEntry]()
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        let priceAxis = chartView.rightAxis
        priceAxis.drawAxisLineEnabled = false
        let timeAxis = chartView.xAxis
        chartView.legend.enabled = false
        priceAxis.gridLineDashLengths = [2, 8]
        return chartView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lineChartView)
        lineChartView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width)
        lineChartView.center = view.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.loadCompanyInfoAndPrice { error in
            if error != nil {
                self.showAlert(with: "Reason", message: error!.localizedDescription)
                return
            }
            guard let item = self.model.selectedCompanyItem else { return }
            DispatchQueue.main.async {
                self.navigationItem.title = item.companyName
                self.companyName.text = item.companyName
                self.priceLabel.text = "$\(Double(item.currentPrice))"
                if item.priceChange > 0 {
                    self.priceChangeLabel.text = "+" + String(format: "%.2f", item.priceChangePercentage!) + "%" + "|" + "$" + String(format: "%.2f", abs(item.priceChange!))
                    self.priceChangeLabel.textColor = UIColor.systemGreen
                } else {
                    self.priceChangeLabel.text = String(format: "%.2f", item.priceChangePercentage!) + "%" + " | " + "$" + String(format: "%.2f", abs(item.priceChange!))
                    self.priceChangeLabel.textColor = UIColor.systemRed
                }
                self.addToFavouritesButtonIsSelected = item.isFavourite
                self.updateFavouritesButtonImage()
            }
        }
        model.loadChart(with: .day, completion: {
            DispatchQueue.main.async {
                guard let candles = self.model.companyItems.select(by: self.model.selectedTicker!)?.candles else { return }
                assert(candles.price.count == candles.time.count)
                for i in 0..<candles.price.count {
                    let x = Double(candles.time[i])
                    let y = candles.price[i]
                    self.values.append(ChartDataEntry(x: x, y: y))
                }
                self.setData(self.values)
                self.lineChartView.notifyDataSetChanged()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        model.selectedTicker = nil
        model.selectedCompanyItem = nil
    }
    
    @IBAction func chartDidChange(_ sender: UISegmentedControl) {
        let loadChartCompletion: (_ resolution: FHResolution) -> () = {
            self.model.loadChart(with: $0, completion: {
                self.values.removeAll()
                DispatchQueue.main.async {
                    guard let candles = self.model.companyItems.select(by: self.model.selectedTicker!)?.candles else { return }
                    assert(candles.price.count == candles.time.count)
                    for i in 0..<candles.price.count {
                        let x = Double(candles.time[i])
                        let y = candles.price[i]
                        self.values.append(ChartDataEntry(x: x, y: y))
                    }
                    self.setData(self.values)
                    self.lineChartView.notifyDataSetChanged()
                }
            })
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            loadChartCompletion(.day)
        case 1:
            loadChartCompletion(.week)
        case 2:
            loadChartCompletion(.month)

        default:
            loadChartCompletion(.day)

        }
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToFavouritesButtonDidTap(_ sender: UIButton) {
        addToFavouritesButtonIsSelected = !addToFavouritesButtonIsSelected
        let selectedStockIndex = model.companyItems.selectIndex(by: model.selectedTicker!)
        model.companyItems[selectedStockIndex!].isFavourite = addToFavouritesButtonIsSelected
        updateFavouritesButtonImage()
    }
    
    func updateFavouritesButtonImage() {
        addToFavouritesButtonIsSelected
            ? favouritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            : favouritesButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    func setData(_ data: [ChartDataEntry]?) {
        let chartDataSet = LineChartDataSet(entries: data)
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.lineWidth = 2
        if values.first!.y < values.last!.y {
            chartDataSet.setColor(.systemGreen)
            chartDataSet.fill = Fill(color: .systemGreen)
        } else if values.first!.y > values.last!.y {
            chartDataSet.setColor(.systemRed)
            chartDataSet.fill = Fill(color: .systemRed)
        } else {
            chartDataSet.setColor(.systemGray)
            chartDataSet.fill = Fill(color: .systemGray)
        }
        chartDataSet.fillAlpha = 0.2
        chartDataSet.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: chartDataSet)
        data.setDrawValues(false)
        lineChartView.data = data
    }
}

