//
//  FHQuote.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 09.03.2021.
//

import Foundation

struct FHQuote: Decodable {
    let c: Double
    let h: Double
    let l: Double
    let o: Double
    let pc: Double
}
