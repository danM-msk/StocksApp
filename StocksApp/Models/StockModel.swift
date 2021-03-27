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
    private let trendingTickers = ["AAPL", "TSLA", "GOOGL", "MSFT", "AMZN", "MA", "BAC", "F", "JPM", "AAL", "CSCO", "GE", "XOM", "LOGI"]
//    private let trendingTickers = ["AAPL"]
    var favouriteTickers = [StockItem]()
    var companyItems = [StockItem]()
    var availableCompanies = [FHStock]()
    var selectedTicker: String?
    var selectedCompanyItem: StockItem?
    
    func loadCompanyInfoAndPrice(with completion: @escaping () -> Void) {
        provider.fetchCompanyInfoAndPrice(by: selectedTicker!) { (loadedStockItem, error) in
            self.selectedCompanyItem = loadedStockItem
            completion()
        }
    }
    
    func loadCompaniesInfoAndPrice(with completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for ticker in trendingTickers {
            dispatchGroup.enter()
            provider.fetchCompanyInfoAndPrice(by: ticker) { (loadedStockItem, error) in
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
        provider.fetchChart(by: selectedTicker!, resolution: .day) { (loadedCandles, error) in
            guard let item = self.companyItems.selectBy(ticker: self.selectedTicker!) else { return }
            item.candles = loadedCandles
            completion()
        }
    }
    
    func loadWeekChart(with completion: @escaping () -> Void) {
        provider.fetchChart(by: selectedTicker!, resolution: .week) { (loadedCandles, error) in
            guard let item = self.companyItems.selectBy(ticker: self.selectedTicker!) else { return }
            item.candles = loadedCandles
            completion()
        }
    }
    
    func loadMonthChart(with completion: @escaping () -> Void) {
        provider.fetchChart(by: selectedTicker!, resolution: .month) { (loadedCandles, error) in
            guard let item = self.companyItems.selectBy(ticker: self.selectedTicker!) else { return }
            item.candles = loadedCandles
            completion()
        }
    }
}
