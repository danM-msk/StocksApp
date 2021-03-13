//
//  FHCompany.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 11.03.2021.
//

import Foundation

struct FHCompany: Decodable {
    let country: String
    let currency: String
    let exchange: String
    let ipo: String
    let marketCapitalization: Double
    let name: String
    let phone: String
    let shareOutstanding: Double
    let ticker: String
    let weburl: String
    let logo: String
    let finnhubIndustry: String
}
