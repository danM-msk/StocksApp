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
