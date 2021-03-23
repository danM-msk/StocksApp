//
//  StockCandles.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 23.03.2021.
//

import Foundation

struct FHStockCandles: Codable {
    let price: [Double]
    let time: [Int]
    
    enum CodingKeys: String, CodingKey {
        case price = "c"
        case time = "t"
    }
}
