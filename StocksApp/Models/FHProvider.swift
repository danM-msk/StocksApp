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
        let urlString = "\(baseURL)/stock/profile2?symbol=\(ticker)&token=\(apiKey)"
        let request = AF.request(urlString)
        request.responseDecodable(of: FHCompany.self) { (response) in
            
            if response.error != nil {
                completion(nil, response.error)
            }
            
            let data = response.value
            completion(data, nil)
        }
    }
    
//    func performRequest(_ urlString: String, completion: @escaping (FHQuote?, Error?) -> Void) {
//        // 1. Creating a URL
//        if let url = URL(string: urlString) {
//            // 2. Creating a URLSession
//            let session = URLSession(configuration: .default)
//            // 3. Giving the session a task
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if error != nil {
//                    print(error!)
//                    return
//                }
//                if let data = data {
//                    let stock = self.parseJSON(data)
//                    if (stock != nil) {
//                        completion(stock, error)
//                    }
//                }
//                completion(nil, error)
//            }
//            // 4. Starting the task
//            task.resume()
//        }
//    }

    
    func parseJSON(_ data: Data) -> FHQuote?{
        let decoder = JSONDecoder()
        var stockData: FHQuote? = nil
        do {
            stockData = try decoder.decode(FHQuote.self, from: data)
        } catch {
            print(error)
//            return nil
        }
        return stockData;
    }
    
}
