//
//  StockModel.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 11.03.2021.
//

import Foundation

class StockModel {
    static let instance = StockModel()
    private let provider = FHProvider.instance
    var defaultTickers = ["AAPL", "TSLA", "GOOGL", "MSFT", "AMZN", "MA", "BAC", "F", "JPM", "AAL", "CSCO", "GE", "XOM", "LOGI"]
    var companyItems = [StockItem]()
    var availableCompanies = [FHStock]()
    var selectedTicker: String?
    
    func loadDetails(with completion: @escaping (StockItem?, Error?) -> Void) {
        provider.fetchCompanyInfoAndPrice(by: selectedTicker!) { loadedStockItem, error in
            completion(loadedStockItem, error)
        }
    }
    
    func loadStocks(with completion: @escaping (Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var allDataHasBeenLoaded = true
        var fetchingError: Error?
        
        for ticker in defaultTickers {
            dispatchGroup.enter()
            provider.fetchCompanyInfoAndPrice(by: ticker) { (loadedStockItem, error) in
                dispatchGroup.leave()
                guard let loadedStockItem = loadedStockItem else {
                    
                    fetchingError = error
                    allDataHasBeenLoaded = false
                    return
                }
                if let existingStockItem = self.companyItems.select(by: ticker) {
                    existingStockItem.updateDetails(from: loadedStockItem)
                } else {
                    self.companyItems.append(loadedStockItem)
                }
            }
        }
        
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            if allDataHasBeenLoaded == true {
                debugPrint("all data has been loaded")
                self.companyItems = self.companyItems.sorted(by: { $0.ticker < $1.ticker })
                completion(nil)
            } else {
                let incorrectDataError = APIError.incorrectData
                print(fetchingError?.localizedDescription ?? incorrectDataError.localizedDescription)
                completion(fetchingError ?? incorrectDataError)
            }
        }
    }
    
    func loadSupportedStocks(with completion: @escaping (Error?) -> Void) {
        availableCompanies.removeAll()
        provider.fetchSupportedStocks { loadedStocks, error in
            guard let stocks = loadedStocks else {
                completion(error)
                return
            }
            self.availableCompanies = stocks
            self.availableCompanies = self.availableCompanies.sorted(by: { $0.ticker! < $1.ticker! })
            completion(nil)
        }
    }
    
    func loadChart(with resolution: FHResolution, completion: @escaping () -> Void) {
        provider.fetchChart(by: selectedTicker!, resolution: resolution) { (loadedCandles, error) in
            guard let item = self.companyItems.select(by: self.selectedTicker!) else { return }
            item.candles = loadedCandles
            completion()
        }
    }
}
