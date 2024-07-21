//
//  Bill.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 7/11/24.
//
//

import Foundation
import SwiftData


@Model class Bill {
    var amount: Double = 0.0
    var category: String = ""
    var company: String = ""
    var frequency: Frequency = Frequency.monthly
    var nextDueDate: Date = Date()
    
    init(amount: Double, category: String, company: String, frequency: Frequency, nextDueDate: Date) {
        self.amount = amount
        self.category = category
        self.company = company
        self.frequency = frequency
        self.nextDueDate = nextDueDate
    }
}
