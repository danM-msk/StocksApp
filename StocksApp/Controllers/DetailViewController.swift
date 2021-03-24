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
    
    let model = StockModel.instance
    var favourites = StockModel.instance.favouriteTickers
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        let priceAxis = chartView.rightAxis
        priceAxis.drawAxisLineEnabled = false
        let timeAxis = chartView.xAxis
        
        return chartView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.loadDayChart {
            DispatchQueue.main.async {
                let tmp = self.lineChartView
                self.lineChartView.notifyDataSetChanged()
            }
        }
        view.addSubview(lineChartView)
        lineChartView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width)
        lineChartView.center = view.center
        companyName.text = model.selectedTicker
    }
    
    var values1 = [ChartDataEntry]()

    @IBAction func GoBack(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func AddToFavourites(_ sender: UIButton) {
        let currentTicker = model.companyItems.first { $0.ticker == model.selectedTicker }
        if (currentTicker != nil) { model.favouriteTickers.append(currentTicker!) }
        dump(model.favouriteTickers)
        }
    
//    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        print(entry)
//    }
    
    func setData(_ data: [ChartDataEntry]?) {
        let set1 = LineChartDataSet(entries: data)
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2
        set1.setColor(.darkGray)
        set1.fill = Fill(color: .darkGray)
        set1.fillAlpha = 0.4
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
}
