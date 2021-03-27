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
    
    func loadCompaniesInfoAndPrice(with completion: @escaping (Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var allDataHasBeenLoaded = true
        var fetchingError: Error?
        
        for ticker in trendingTickers {
            dispatchGroup.enter()
            provider.fetchCompanyInfoAndPrice(by: ticker) { (loadedStockItem, error) in
                dispatchGroup.leave()
                guard let loadedStockItem = loadedStockItem else {
                    fetchingError = error
                    allDataHasBeenLoaded = false
                    return
                }
                self.companyItems.append(loadedStockItem)
            }
        }
        
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            if allDataHasBeenLoaded == true {
                debugPrint("all data has been loaded")
                self.companyItems = self.companyItems.sorted(by: { $0.companyName < $1.companyName })
                completion(nil)
            } else {
                print(fetchingError?.localizedDescription ?? "error while fetching companies and prices")
                self.companyItems.removeAll()
                completion(fetchingError)
            }
        }
    }
    
    func fetchSupportedStocks(with completion: @escaping (Error?) -> Void) {
        provider.fetchSupportedStocks { stocks, error in
            guard let stocks = stocks else {
                completion(error)
                return
            }
            self.availableCompanies = stocks
            completion(nil)
        }
    }
    
    func loadChart(with resolution: FHResolution, completion: @escaping () -> Void) {
        provider.fetchChart(by: selectedTicker!, resolution: resolution) { (loadedCandles, error) in
            guard let item = self.companyItems.selectBy(ticker: self.selectedTicker!) else { return }
            item.candles = loadedCandles
            completion()
        }
    }
}
