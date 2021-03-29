//
//  APIError.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 29.03.2021.
//

import Foundation

enum APIError: Error {
    case incorrectData
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .incorrectData:
            return "Incorrect API Data"
        }
    }
}
