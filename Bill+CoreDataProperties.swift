//
//  Bill+CoreDataProperties.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/19/23.
//
//

import Foundation
import CoreData


extension Bill {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bill> {
        return NSFetchRequest<Bill>(entityName: "Bill")
    }

    @NSManaged public var nextDueDate: Date
    @NSManaged public var frequency: String
    @NSManaged public var amount: Double
    @NSManaged public var company: String
    @NSManaged public var category: String
    

}

extension Bill : Identifiable {

}
