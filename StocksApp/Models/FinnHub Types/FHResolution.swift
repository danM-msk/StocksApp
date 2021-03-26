//
//  FHRange.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 24.03.2021.
//

import Foundation

enum FHResolution: String {
    case day = "5"
    case week = "60"
    case month = "D"
}

extension FHResolution {
    private func startInterval() -> TimeInterval{
        switch self {
        case .day:
            return 86400
        case .week:
            return 604800
        case .month:
            return 2629743
        }
    }
    
    func range() -> Int {
        let now = NSDate().timeIntervalSince1970
        let result = Int(now - self.startInterval())
        return result
    }
}
