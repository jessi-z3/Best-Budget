//
//  Frequency.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/20/23.
//

import Foundation

public enum Frequency: String, CaseIterable, Identifiable, CustomStringConvertible {
    public var id: Frequency { self }

    case annually
    case quarterly
    case monthly
    case everyFourWeeks
    case biWeekly
    case weekly
    
    public var description: String{
        switch self {
            case .annually: return "annually"
            case .quarterly: return "quarterly"
            case .monthly: return "monthly"
            case .everyFourWeeks: return "every four weeks"
            case .biWeekly: return "bi-weekly"
            case .weekly: return "weekly"
        }
    }
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
