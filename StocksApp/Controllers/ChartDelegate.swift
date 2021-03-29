//
//  ChartDelegate.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 29.03.2021.
//

import Foundation
import Charts

class ChartDelegate: ChartViewDelegate {
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
    
    private func updateData() {
        let chartDataSet = LineChartDataSet(entries: values)
        if values.count == 0 {
            lineChartView.data = nil
            lineChartView.notifyDataSetChanged()
            return
        }
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
        lineChartView.notifyDataSetChanged()
    }
    
    func loadData(with resolution: FHResolution) {
        values.removeAll()
        updateData()
        model.loadChart(with: resolution, completion: {
            DispatchQueue.main.async {
                guard let candles = self.model.companyItems.select(by: self.model.selectedTicker!)?.candles else { return }
                assert(candles.price.count == candles.time.count)
                for i in 0..<candles.price.count {
                    let x = Double(candles.time[i])
                    let y = candles.price[i]
                    self.values.append(ChartDataEntry(x: x, y: y))
                }
                self.updateData()
            }
        })
    }
}
