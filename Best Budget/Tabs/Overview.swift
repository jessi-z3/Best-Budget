//
//  Overview.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/21/23.
//

import SwiftUI
import SwiftData

struct Overview: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Bill.nextDueDate) var bills: [Bill]
    @Query(sort: \Income.nextPayDate) var incomes: [Income]
    
    var projectedBalance: Double {
        var total = 0.0
        incomes.forEach { income in
            total += income.balance
        }
        billsThisPeriod.forEach { bill in
            total -= bill.amount
        }
        return total
    }
    
    var outstanding: Bool {
        var count = 0
        incomes.forEach { income in
            if income.outstanding > 0 {
                count += 1
            }
        }
        return count != 0
    }
    
    @State var saved: Bool = false
    @Binding var signedIn: Bool
    var billsThisPeriod: [Bill] {
        determineBillsThisPeriod(bills: bills)
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Overview")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Text("Income:")
                    .fontWeight(.bold)
                    .font(.title2)
                ForEach(incomes) { income in
                    VStack(alignment: .leading) {
                        Text(income.source)
                            .fontWeight(.semibold)
                        HStack {
                            Text("Balance:")
                            Spacer()
                            Text(String(format: "$%.2f", income.balance))
                        }
                        HStack {
                            Text("Next Pay Date:")
                            Spacer()
                            Text(income.nextPayDate, formatter: itemFormatter)
                        }
                    }
                    .font(.title3)
                    Spacer()
                }
                if outstanding == true {
                    HStack {
                        Text("Outstanding:")
                            .fontWeight(.bold)
                            .font(.title2)
                        Spacer()
                        
                        ForEach(incomes) { income in
                            if income.outstanding > 0 {
                                Text(String(format: "$%.2f", income.outstanding))
                                    .font(.title3)
                            }
                        }
                    }
                }
                if !billsThisPeriod.isEmpty {
                    Text("Bills this Period:")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                ForEach(billsThisPeriod) { bill in
                    HStack {
                        Text(bill.company)
                        Spacer()
                        Text(String(format: "$%.2f", bill.amount))
                    }
                }
                
                
                HStack {
                    Text("Projected Balance:")
                        .fontWeight(.bold)
                        .font(.title2)
                    Spacer()
                    Text(String(format: "$%.2f", projectedBalance))
                        .font(.title2)
                }
            }
            .foregroundColor(Color.white)
            .fontWidth(.expanded)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color("Color2"), Color("Color1")]), startPoint: .leading, endPoint: .bottom))
    }
    func determineBillsThisPeriod(bills: [Bill]) -> [Bill] {
        var billsThisPeriod = [Bill]()
        if !incomes.isEmpty {
            if !bills.isEmpty {
                bills.forEach { bill in
                    if bill.nextDueDate <= incomes[0].nextPayDate {
                        billsThisPeriod.append(bill)
                    }
                }
            }
        }
        return billsThisPeriod
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()


struct Overiew_Previews: PreviewProvider {
    static var previews: some View {
        Overview(signedIn: .constant(true))
    }
}
