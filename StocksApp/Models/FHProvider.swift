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
    
    func fetchCompany(with ticker: String, completion: @escaping (FHCompany?, Error?) -> Void) {
        let urlStringCompanyProfile = "\(baseURL)/stock/profile2?symbol=\(ticker)&token=\(apiKey)"
        let requestCompanyProfile = AF.request(urlStringCompanyProfile)
        requestCompanyProfile.responseDecodable(of: FHCompany.self) { (response) in
            
            if response.error != nil {
                completion(nil, response.error)
            }
            
            let data = response.value
            completion(data, nil)
        }
    }
    
    func fetchQuote(with ticker: String, completion: @escaping (FHQuote?, Error?) -> Void) {
        let urlStringQuote = "\(baseURL)/stock/quote?symbol=\(ticker)&token=\(apiKey)"
        let requestQuote = AF.request(urlStringQuote)
        requestQuote.responseDecodable(of: FHQuote.self) { (response) in
            if response.error != nil {
                completion(nil, response.error)
            }
            let data = response.value
            completion(data, nil)
        }
    }
    
    
}
