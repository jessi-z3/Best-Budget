//
//  Income+CoreDataProperties.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/22/23.
//
//

import Foundation
import CoreData


extension Income {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Income> {
        return NSFetchRequest<Income>(entityName: "Income")
    }

    @NSManaged public var nextPayDate: Date?
    @NSManaged public var payFrequency: String?
    @NSManaged public var balance: Double
    @NSManaged public var outstanding: Double

}

extension Income : Identifiable {

}
