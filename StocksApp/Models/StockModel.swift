//
//  StockModel.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 11.03.2021.
//

import Foundation

class StockModel {
    static let instance = StockModel()
    
    let stockManager = FHProvider.instance
    
    private var tickers: [String] = ["AAPL", "TSLA", "GOOGL", "MSFT", "AMZN", "MA"]
    var quotes: [FHQuote] = []
    var companies: [FHCompany] = []
    
    func loadData() {
        for ticker in tickers {
            stockManager.fetchCompany(with: ticker) { (company, error) in
                if error != nil {
                    fatalError("Error while loading company")
                }
                
                guard let company = company else { return }
                self.companies.append(company)
            }
        }
    }
}
