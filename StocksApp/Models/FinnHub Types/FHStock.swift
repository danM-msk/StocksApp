//
//  FHStock.swift
//  FinMonitor
//
//  Created by Daniyar Mamadov on 04.03.2021.
//

import Foundation

struct FHStock : Codable {
    var ticker: String? // symbol, display symbol
    var title: String?
    var currency: String?
    var type: String?
    var figi: String?
    var mic: String?
    
    enum CodingKeys: String, CodingKey {
        case ticker = "symbol"
        case title = "desctiption"
        case currency
        case type
        case figi
        case mic
      }
}
