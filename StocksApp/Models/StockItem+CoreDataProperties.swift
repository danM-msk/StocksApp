//
//  StockItem+CoreDataProperties.swift
//  
//
//  Created by Daniyar Mamadov on 28.03.2021.
//
//

import Foundation
import CoreData


extension StockItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockItem> {
        return NSFetchRequest<StockItem>(entityName: "StockItem")
    }

    @NSManaged public var ticker: String?
    @NSManaged public var companyName: String?
    @NSManaged public var currentPrice: Double
    @NSManaged public var priceChange: Double
    @NSManaged public var priceChangePercentage: Double

}
