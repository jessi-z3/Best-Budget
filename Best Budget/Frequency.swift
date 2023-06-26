//
//  Frequency.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/20/23.
//

import Foundation

public enum Frequency: String, CaseIterable, Identifiable {
    public var id: Self { self }

    case annually = "annually"
    case quarterly = "quarterly"
    case monthly = "monthly"
    case everyFourWeeks = "every four weeks"
    case biWeekly = "bi-weekly"
    case weekly = "weekly"
}
func getNextDueDate(frequency: Frequency, bill: Bill) -> Date {
    
    switch frequency {
        case .annually: bill.nextDueDate += (365 * 86400); return bill.nextDueDate;
        case .quarterly: bill.nextDueDate += (89 * 86400); return bill.nextDueDate;
        case .monthly: bill.nextDueDate += (30 * 86400); return bill.nextDueDate;
        case .everyFourWeeks: bill.nextDueDate += (28 * 86400); return bill.nextDueDate;
        case .biWeekly: bill.nextDueDate += (14 * 86400); return bill.nextDueDate;
        case .weekly: bill.nextDueDate += (7 * 86400); return bill.nextDueDate;
    }
}
func getNextPayDate(frequency: Frequency, income: Income) -> Date {
    
    switch frequency {
        case .annually: income.nextPayDate += (365 * 86400); return income.nextPayDate;
        case .quarterly: income.nextPayDate += (89 * 86400); return income.nextPayDate;
        case .monthly: income.nextPayDate += (30 * 86400); return income.nextPayDate;
        case .everyFourWeeks: income.nextPayDate += (28 * 86400); return income.nextPayDate;
        case .biWeekly: income.nextPayDate += (14 * 86400); return income.nextPayDate;
        case .weekly: income.nextPayDate += (7 * 86400); return income.nextPayDate;
    }
}
