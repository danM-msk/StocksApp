//
//  StockModel.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 11.03.2021.
//

import Foundation

class StockModel {
    static let instance = StockModel()
    static let detailVC = DetailViewController()
    private let provider = FHProvider.instance
//    private let tickers = ["MMM", "AXP","T", "BA", "CAT", "CVX", "CSCO", "DD", "XOM", "GE", "GS", "INTC", "IBM", "JNJ", "JPM", "MCD", "MRK", "MSFT", "NKE", "PFE", "PG", "KO", "HD", "TRV", "UTX", "UNH", "VZ", "V", "WMT", "DIS"]
//    private let tickers = ["MMM", "AXP","T", "BA", "CAT", "CVX", "CSCO", "DD", "XOM", "GE", "GS", "INTC", "IBM", "JNJ", "JPM", "MCD", "MRK", "MSFT", "NKE", "PFE", "PG", "KO", "HD", "TRV", "UTX", "UNH", "VZ", "V"]
    private let tickers = ["AAPL", "TSLA", "GOOGL", "MSFT", "AMZN", "MA"]
    
    var favouriteTickers = [StockItem]()
    
    var companyItems = [StockItem]()
    var availableCompanies = [FHStock]()
    var dayChart = [FHStockCandles]()
    
    var selectedTicker: String?
    
    func loadCompanies(with completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for ticker in tickers {
            dispatchGroup.enter()
            provider.fetchCompanyInfoAndPrice(by: ticker) { (loadedStockItem, erro) in
                dispatchGroup.leave()
                self.companyItems.append(loadedStockItem!)
            }
        }
        
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            debugPrint("all data has been loaded")
            self.companyItems = self.companyItems.sorted(by: { $0.companyName < $1.companyName })
            completion()
        }
    }
    
    func fetchSupportedStocks(with completion: @escaping () -> Void) {
        provider.fetchSupportedStocks { stocks, error in
            self.availableCompanies = stocks!
            completion()
        }
    }
    
    func loadDayChart(with completion: @escaping () -> Void) {
        var data = [FHStockCandles]()
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        provider.fetchDayChart(with: tickers) { (loadedData, error) in
            dispatchGroup.leave()
            data = loadedData!
        }
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            debugPrint("Chart has been loaded")
            for i in 0..<data.count {
                let chart = FHStockCandles(price: [Double(i)], time: [i])
                self.dayChart.append(chart)                }
            completion()
        }
    }
}
