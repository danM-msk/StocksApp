//
//  FHProvider.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 10.03.2021.
//

import Foundation
import Alamofire

class FHProvider: Provider {
    let baseURL = "https://finnhub.io/api/v1"
    let apiKey = "c10hqqf48v6ujh08p12g"
    
    static let instance = FHProvider()
    
    func fetchSupportedStocks(with completion: @escaping ([FHStock]?, Error?) -> Void) {
        let url = "\(baseURL)/stock/symbol?token=\(apiKey)&exchange=US"
        super.fetchData(with: url, completion: completion)
    }
    
    func fetchCompanies(with tickers: [String], completion: @escaping ([FHCompany]?, Error?) -> Void) {
        let url = "\(baseURL)/stock/profile2?token=\(apiKey)"
        super.fetchDataEntries(tickers, with: url, key: "symbol", completion: completion)
    }
    
    func fetchCompaniesPrices(with tickers: [String], completion: @escaping ([FHQuote]?, Error?) -> Void) {
        let url = "\(baseURL)/quote?token=\(apiKey)"
        super.fetchDataEntries(tickers, with: url, key: "symbol", completion: completion)
    }
    
    func fetchCompanyProfile(by ticker: String, completion: @escaping (FHCompany?, Error?) -> Void) {
        let url = "\(baseURL)/stock/profile2?token=\(apiKey)&symbol=\(ticker)"
        super.fetchData(with: url, completion: completion)
    }
    
    func fetchCompanyPrice(by ticker: String, completion: @escaping (FHQuote?, Error?) -> Void) {
        let url = "\(baseURL)/quote?token=\(apiKey)&symbol=\(ticker)"
        super.fetchData(with: url, completion: completion)
    }
}
