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
    var priceChangePercentage: Double?
    var candles: FHStockCandles?
    var isFavourite = false
    
    var country: String?
    var currency: String?
    var exchange: String?
    var ipo: String?
    var marketCapitalization: Double?
    var shareOutstanding: Double?
    var logoUrl: String?
    var phone: String?
    var weburl: String?
    var finnhubindustry: String?
    
    init(_ company: FHCompanyInfo, quote: FHQuote) {
        self.companyName = company.name
        self.currentPrice = quote.currentPrice
        self.ticker = company.ticker
        self.priceChange = quote.currentPrice - quote.openPrice
        self.priceChangePercentage = (self.priceChange/quote.openPrice)*100
        self.country = company.country
        self.currency = company.currency
        self.exchange = company.exchange
        self.ipo = company.ipo
        self.marketCapitalization = company.marketCapitalization
        self.shareOutstanding = company.shareOutstanding
        self.logoUrl = company.logoUrl
        self.phone = company.phone
        self.weburl = company.weburl
        self.finnhubindustry = company.finnhubindustry
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
    func select(by ticker: String) -> StockItem? {
        for item in self {
            if item.ticker == ticker { return item }
        }
        return nil
    }
    
    func selectIndex(by ticker: String) -> Int? {
        var i = 0
        for item in self {
            if item.ticker == ticker { return i }
            i += 1
        }
        return nil
    }
    
    var favourites: [StockItem] {
        get {
            let filtered = self.filter { item -> Bool in
                return item.isFavourite
            }
            return filtered
        }
    }
}
