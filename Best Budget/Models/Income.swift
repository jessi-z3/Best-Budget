//
//  Income.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 7/11/24.
//
//

import Foundation
import SwiftData


@Model class Income {
    var source: String = ""
    var balance: Double = 0.0
    var nextPayDate: Date = Date()
    var outstanding: Double = 0.0
    var payFrequency: Frequency = Frequency.biWeekly
    
    init(source: String, balance: Double, nextPayDate: Date, outstanding: Double, payFrequency: Frequency) {
        self.source = source
        self.balance = balance
        self.nextPayDate = nextPayDate
        self.outstanding = outstanding
        self.payFrequency = payFrequency
    }
}
