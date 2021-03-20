//
//  FHCompany.swift
//  FinMonitor
//
//  Created by Daniyar Mamadov on 17.03.2021.
//

import Foundation

struct FHCompany : Codable {
    var country: String?
    var currency: String?
    var exchange: String?
    var name: String?
    var ticker: String?
    var ipo: String?
    var marketCapitalization: Double?
    var shareOutstanding: Double?
    var logoUrl: String?
    var phone: String?
    var weburl: String?
    var finnhubindustry: String?
    
    enum CodingKeys: String, CodingKey {
        case country
        case currency
        case exchange
        case name
        case ticker
        case ipo
        case marketCapitalization
        case shareOutstanding
        case logoUrl = "logo"
        case phone
        case weburl
        case finnhubindustry
    }
}
