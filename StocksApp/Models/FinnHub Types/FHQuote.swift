//
//  FHQuote.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 17.03.2021.
//

import Foundation

struct FHQuote: Codable {
    var currentPrice: Double
    var highestPrice: Double
    var lowestPrice: Double
    var openPrice: Double
    var previousClosePrice: Double
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "c"
        case openPrice = "o"
        case highestPrice = "h"
        case lowestPrice = "l"
        case previousClosePrice = "pc"
    }
}
