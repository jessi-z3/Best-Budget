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
    var dateComponent = DateComponents()

    switch frequency {
        case .annually: dateComponent.year = 1; dateComponent.day = 0; dateComponent.month = 0; bill.nextDueDate = Calendar.current.date(byAdding: dateComponent, to: bill.nextDueDate)!; return bill.nextDueDate;
        case .quarterly: dateComponent.year = 0; dateComponent.day = 0; dateComponent.month = 3; bill.nextDueDate = Calendar.current.date(byAdding: dateComponent, to: bill.nextDueDate)!; return bill.nextDueDate;
        case .monthly: dateComponent.year = 0; dateComponent.day = 0; dateComponent.month = 1; bill.nextDueDate = Calendar.current.date(byAdding: dateComponent, to: bill.nextDueDate)!; return bill.nextDueDate;
        case .everyFourWeeks: dateComponent.year = 0; dateComponent.day = 28; dateComponent.month = 0; bill.nextDueDate = Calendar.current.date(byAdding: dateComponent, to: bill.nextDueDate)!; return bill.nextDueDate;
        case .biWeekly: dateComponent.year = 0; dateComponent.day = 14; dateComponent.month = 0; bill.nextDueDate = Calendar.current.date(byAdding: dateComponent, to: bill.nextDueDate)!; return bill.nextDueDate;
        case .weekly: dateComponent.year = 0; dateComponent.day = 7; dateComponent.month = 0; bill.nextDueDate = Calendar.current.date(byAdding: dateComponent, to: bill.nextDueDate)!; return bill.nextDueDate;
    }
}
func getNextPayDate(frequency: Frequency, income: Income) -> Date {
    var dateComponent = DateComponents()
    
    switch frequency {
    case .annually: dateComponent.year = 1; dateComponent.day = 0; dateComponent.month = 0; income.nextPayDate = Calendar.current.date(byAdding: dateComponent, to: income.nextPayDate)!; return income.nextPayDate;
        case .quarterly: dateComponent.year = 0; dateComponent.day = 0; dateComponent.month = 3; income.nextPayDate = Calendar.current.date(byAdding: dateComponent, to: income.nextPayDate)!; return income.nextPayDate;
        case .monthly: dateComponent.year = 0; dateComponent.day = 0; dateComponent.month = 1; income.nextPayDate = Calendar.current.date(byAdding: dateComponent, to: income.nextPayDate)!; return income.nextPayDate;
        case .everyFourWeeks: dateComponent.year = 0; dateComponent.day = 28; dateComponent.month = 0; income.nextPayDate = Calendar.current.date(byAdding: dateComponent, to: income.nextPayDate)!; return income.nextPayDate;
        case .biWeekly: dateComponent.year = 0; dateComponent.day = 14; dateComponent.month = 0; income.nextPayDate = Calendar.current.date(byAdding: dateComponent, to: income.nextPayDate)!; return income.nextPayDate;
        case .weekly: dateComponent.year = 0; dateComponent.day = 7; dateComponent.month = 0; income.nextPayDate = Calendar.current.date(byAdding: dateComponent, to: income.nextPayDate)!; return income.nextPayDate;
    }
}
