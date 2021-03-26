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
    
    func fetchCompanyInfoAndPrice(by ticker: String, completion: @escaping (StockItem?, Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var companyInfo: FHCompanyInfo?
        var quote: FHQuote?
        
        dispatchGroup.enter()
        AF.request("\(baseURL)/stock/profile2?token=\(apiKey)&symbol=\(ticker)", method: .get)
            .validate()
            .responseDecodable(of: FHCompanyInfo.self) { response in
                dispatchGroup.leave()
                switch response.result {
                case .success:
                    companyInfo = response.value!
                case let .failure(error):
                    completion(nil, error)
                }
            }
        
        dispatchGroup.enter()
        AF.request("\(baseURL)/quote?token=\(apiKey)&symbol=\(ticker)", method: .get)
            .validate()
            .responseDecodable(of: FHQuote.self) { response in
                dispatchGroup.leave()
                switch response.result {
                case .success:
                    quote = response.value!
                case let .failure(error):
                    completion(nil, error)
                }
            }
        
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            debugPrint("company info and price has been loaded")
            let item = StockItem(companyInfo!, quote: quote!)
            completion(item, nil)
        }
        
    }
    
    func fetchCompanyProfile(by ticker: String, completion: @escaping (FHCompanyInfo?, Error?) -> Void) {
        let url = "\(baseURL)/stock/profile2?token=\(apiKey)&symbol=\(ticker)"
        super.fetchData(with: url, completion: completion)
    }
    
    func fetchCompanyPrice(by ticker: String, completion: @escaping (FHQuote?, Error?) -> Void) {
        let url = "\(baseURL)/quote?token=\(apiKey)&symbol=\(ticker)"
        super.fetchData(with: url, completion: completion)
    }
    
    func fetchChart(by ticker: String, resolution: FHResolution, completion: @escaping (FHStockCandles?, Error?) -> Void) {
        let url = "\(baseURL)/stock/candle?resolution=\(resolution.rawValue)&from=\(resolution.range())&to=\(Int(NSDate().timeIntervalSince1970))&token=\(apiKey)&symbol=\(ticker)"
        super.fetchData(with: url, completion: completion)
    }
}
