//
//  FHProvider.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 10.03.2021.
//

import Foundation
import Alamofire

struct FHProvider {
    let baseURL = "https://finnhub.io/api/v1"
    let apiKey = "c10hqqf48v6ujh08p12g"
    
    static let instance = FHProvider()
    
    func fetchSupportedStocks(with completion: @escaping ([FHStock]?, Error?) -> Void) {
        let request = AF.request("\(baseURL)/stock/symbol", method: .get, parameters: ["token": apiKey, "exchange": "ME"])
        
        request.validate().responseDecodable(of: [FHStock].self) { response in
            switch response.result {
            case .success:
                let stocks = response.value
                completion(stocks, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
    
    func fetchCompanies(with tickers: [String], completion: @escaping ([FHCompany]?, Error?) -> Void) {
        let fetchGroup = DispatchGroup()
        var companies = [FHCompany]()
        tickers.forEach { ticker in
            fetchGroup.enter()
            AF.request("\(baseURL)/stock/profile2", method: .get, parameters: ["token": apiKey, "symbol": ticker])
                .validate()
                .responseDecodable(of: FHCompany.self) { response in
                    if let company = response.value {
                        companies.append(company)
                    }
                    fetchGroup.leave()
                }
        }
        
        fetchGroup.notify(queue: .global(qos: .userInitiated)) {
            print("loaded \(companies.count) companies")
            completion(companies, nil)
        }
    }
    
    func fetchCompaniesPrices(with tickers: [String], completion: @escaping ([FHQuote]?, Error?) -> Void) {
        let fetchGroup = DispatchGroup()
        var quotes = [FHQuote]()
        tickers.forEach { ticker in
            fetchGroup.enter()
            AF.request("\(baseURL)/quote", method: .get, parameters: ["token": apiKey, "symbol": ticker])
                .validate()
                .responseDecodable(of: FHQuote.self) { response in
                    if let quote = response.value {
                        quotes.append(quote)
                    }
                    fetchGroup.leave()
                }
        }
        
        fetchGroup.notify(queue: .global(qos: .userInitiated)) {
            print("loaded \(quotes.count) prices")
            completion(quotes, nil)
        }
    }
    
    func fetchCompanyProfile(by ticker: String, completion: @escaping (FHCompany?, Error?) -> Void) {
        let request = AF.request("\(baseURL)/stock/profile2", method: .get, parameters: ["token": apiKey, "symbol": ticker])
        
        request.validate().responseDecodable(of: FHCompany.self) { response in
            switch response.result {
            case .success:
                let company = response.value
                completion(company, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
    
    func fetchCompanyPrices(by ticker: String, completion: @escaping (FHQuote?, Error?) -> Void) {
        let request = AF.request("\(baseURL)/quote", method: .get, parameters: ["token": apiKey, "symbol": ticker])
        
        request.validate().responseDecodable(of: FHQuote.self) { response in
            switch response.result {
            case .success:
                let quote = response.value
                completion(quote, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
}
