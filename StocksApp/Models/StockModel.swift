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
//    private let tickers = ["MMM", "AXP","T", "BA", "CAT", "CVX", "CSCO", "DD", "XOM", "GE", "GS", "INTC", "IBM", "JNJ", "JPM", "MCD", "MRK", "MSFT", "NKE", "PFE", "PG", "KO", "HD", "TRV", "UTX", "UNH", "VZ", "V", "WMT", "DIS"]
    private let tickers = ["AAPL", "TSLA", "GOOGL", "MSFT", "AMZN", "MA"]
    var companyItems = [FHCompanyItem]()
    
    func loadCompanies(with completion: @escaping () -> Void) {
        var companies = [FHCompany]()
        var quotes = [FHQuote]()
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        provider.fetchCompanies(with: tickers) { loadedCompanies, error in
            dispatchGroup.leave()
            companies = loadedCompanies!
        }
        
        dispatchGroup.enter()
        provider.fetchCompaniesPrices(with: tickers) { loadedQuotes, error in
            dispatchGroup.leave()
            quotes = loadedQuotes!
        }
        
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            debugPrint("all data has been loaded")
            if (companies.count != quotes.count) { return }
            for i in 0..<companies.count {
                let item = FHCompanyItem(companies[i], quote: quotes[i])
                self.companyItems.append(item)
            }
            self.companyItems = self.companyItems.sorted(by: { $0.companyName < $1.companyName })
            completion()
        }
        
    }
}
