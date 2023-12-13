//
//  BillsThisPeriod.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 8/17/23.
//

import SwiftUI

struct BillsThisPeriod: View {
    @Environment(\.managedObjectContext) private var viewContext

    var bills: FetchedResults<Bill>
    var income: Income
    
    var body: some View {
        VStack{
            HStack{
                Text("\(income.incomeName) Balance:").fontWeight(.bold).font(.title2).foregroundStyle(Color.white)
                Spacer()
                Text(String(format: "$%.2f", income.balance)).font(.title3).foregroundStyle(Color.white)
            }
            HStack{
                Text("Outstanding:").fontWeight(.bold).font(.title2).foregroundStyle(Color.white)
                Spacer()
                Text(String(format: "$%.2f", income.outstanding)).foregroundStyle(Color.white).font(.title3)
            }
            HStack{
                Text("Paid: ").fontWeight(.bold).font(.title2)
                Text(Frequency(rawValue: income.payFrequency)?.description ?? income.payFrequency)
                Spacer()
                Text(itemFormatter.string(from:income.nextPayDate))
            }
            .foregroundStyle(Color.white)
        }
    }
}
private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
    formatter.currencyCode = "USD"
    formatter.currencySymbol = "$"
        return formatter
    }()
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    formatter.dateFormat = "MMMM dd"
    return formatter
}()

