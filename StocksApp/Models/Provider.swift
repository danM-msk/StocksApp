//
//  Provider.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 22.03.2021.
//

import Foundation
import Alamofire

class Provider {
    public func fetchData<T: Decodable>(with url: String, completion: @escaping (T?, Error?) -> Void) {
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success:
                    let decodedItem = response.value!
                    completion(decodedItem, nil)
                case let .failure(error):
                    Alert.showLimitAlert(on: MainViewController())
                    completion(nil, error)
                }
            }
    }
    
    public func fetchDataEntries<T: Decodable>(_ entries: Array<String>, with url: String, key: String, completion: @escaping ([T]?, Error?) -> Void) {
        let fetchGroup = DispatchGroup()
        var loadedEntries = [T]()
        
        entries.forEach { entry in
            fetchGroup.enter()
            AF.request("\(url)&\(key)=\(entry)")
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success:
                        let decodedItem = response.value!
                        loadedEntries.append(decodedItem)
                    case let .failure(error):
                        Alert.showLimitAlert(on: MainViewController())
                        print("failed to load \(String(describing: T.self)): \(error)")
                    }
                    fetchGroup.leave()
                }
        }
        
        fetchGroup.notify(queue: .global(qos: .userInitiated)) {
            print("loaded \(loadedEntries.count) \(String(describing: T.self)) data entries")
            completion(loadedEntries, nil)
        }
    }
}
