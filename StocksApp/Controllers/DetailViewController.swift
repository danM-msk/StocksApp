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
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var favouritesButton: UIButton!
    
    var addToFavouritesButtonIsSelected = false
    
    let model = StockModel.instance
    var favourites = StockModel.instance.favouriteTickers
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
        model.loadCompanyInfoAndPrice {
            guard let item = self.model.selectedCompanyItem else { return }
            self.model.selectedCompanyItem = item
            DispatchQueue.main.async {
                self.companyName.text = self.model.selectedCompanyItem?.companyName
            }
        }
        model.loadChart(with: .day, completion: {
            DispatchQueue.main.async {
                guard let candles = self.model.companyItems.selectBy(ticker: self.model.selectedTicker!)?.candles else { return }
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
    }
    
    @IBAction func chartDidChange(_ sender: UISegmentedControl) {
        let loadChartCompletion: (_ resolution: FHResolution) -> () = {
            self.model.loadChart(with: $0, completion: {
                self.values.removeAll()
                DispatchQueue.main.async {
                    guard let candles = self.model.companyItems.selectBy(ticker: self.model.selectedTicker!)?.candles else { return }
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
        updateAddToFavouritesButton()
    }
    func updateAddToFavouritesButton() {
        if addToFavouritesButtonIsSelected {
            favouritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            
        }
        else {
            favouritesButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        let currentTicker = model.companyItems.selectBy(ticker: model.selectedTicker!)
        if (currentTicker != nil) { model.favouriteTickers.append(currentTicker!) }
        print(model.favouriteTickers[0].ticker)
    }
    
    
    func setData(_ data: [ChartDataEntry]?) {
        let set1 = LineChartDataSet(entries: data)
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2
        if values.first!.y < values.last!.y {
            set1.setColor(.systemGreen)
            set1.fill = Fill(color: .systemGreen)
        } else if values.first!.y > values.last!.y {
            set1.setColor(.systemRed)
            set1.fill = Fill(color: .systemRed)
        } else {
            set1.setColor(.systemGray)
            set1.fill = Fill(color: .systemGray)
        }
        set1.fillAlpha = 0.2
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
}

