//
//  StockModel.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 11.03.2021.
//

import Foundation

class StockModel {
    static let instance = StockModel()
    
    let stockManager = StockManager.instance
    
    private var tickers: [String] = ["AAPL", "TSLA", "GOOGL", "MSFT", "AMZN", "MA"]
    var quotes: [FHQuote]
    var companies: [FHCompany]
    
    func loadData() {
        for ticker in tickers {
            stockManager.fetchStock(with: ticker) { (quote, error) in
                <#code#>
            }
        }
    }
}
