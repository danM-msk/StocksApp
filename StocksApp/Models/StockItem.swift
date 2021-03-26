//
//  FHCompanyItem.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 18.03.2021.
//

import Foundation

class StockItem {
    var ticker: String!
    var companyName: String!
    var currentPrice: Double!
    var priceChange: Double!
    var candles: FHStockCandles?
    
    init(_ company: FHCompanyInfo, quote: FHQuote) {
        self.companyName = company.name
        self.currentPrice = quote.currentPrice
        self.ticker = company.ticker
        self.priceChange = quote.currentPrice - quote.openPrice
    }
    
    func updatePrices(_ quote: FHQuote) {
        self.currentPrice = quote.currentPrice
        self.priceChange = quote.currentPrice - quote.openPrice
    }
    
    func updateCompanyInfo(_ company: FHCompanyInfo) {
        self.companyName = company.name
        self.ticker = company.ticker
    }
}

extension Array where Element == StockItem {
    func selectBy(ticker: String) -> StockItem? {
        for item in self {
            if item.ticker == ticker { return item }
        }
        return nil
    }
}
