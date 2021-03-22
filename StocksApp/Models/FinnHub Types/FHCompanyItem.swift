//
//  FHCompanyItem.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 18.03.2021.
//

import Foundation

class FHCompanyItem {
    var ticker: String!
    var companyName: String!
    var currentPrice: Double!
    var priceChange: Double!
    
    init(_ company: FHCompany, quote: FHQuote) {
        self.companyName = company.name
        self.currentPrice = quote.currentPrice
        self.ticker = company.ticker
        self.priceChange = quote.currentPrice - quote.openPrice
    }
}
