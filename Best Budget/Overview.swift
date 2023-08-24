//
//  Overview.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/21/23.
//

import SwiftUI

struct Overview: View {

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Bill.nextDueDate, ascending: true)],
        animation: .default)
    var bills: FetchedResults<Bill>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Income.nextPayDate, ascending: true)],
        animation: .default)
    private var incomes: FetchedResults<Income>

    @State var projected: Double = 0.00

    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 15){
                    Text("Overview").font(.largeTitle).fontWeight(.bold).foregroundStyle(Color.white)
                    
                    ForEach(incomes){ income in
                        BillsThisPeriod(bills: bills, income: income)
                    }
                    Spacer()
                    HStack{
                        Text("Bills this period:")
                            .fontWeight(.bold)
                            .font(.title2)
                            .foregroundStyle(Color.white)
                        Spacer()
                    }
                    ForEach(bills){ bill in
                        if bill.nextDueDate < incomes[0].nextPayDate{
                            HStack{
                                Text(bill.company)
                                    .foregroundStyle(Color.white)
                                Spacer()
                                Text(String(format: "$%.2f", bill.amount))
                                    .foregroundStyle(Color.white)
                            }
        
                        }
                    }
                    if ( bills.isEmpty) {
                        HStack{
                            Text("No Bills Added").fontWeight(.bold)
                                .font(.title2)
                                .foregroundStyle(Color.white)
                        }
                    }
                    HStack{
                        Text("Projected Balance:")
                            .fontWeight(.bold)
                            .font(.title2)
                            .foregroundStyle(Color.white)
                        Spacer()
                        Text(String(format: "$%.2f", projected))
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundStyle(projected < 0.00 ? Color.red : Color.green)
                    }
                }
                .fontWidth(.expanded)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(5)
                .onAppear{
                    incomes.forEach{ income in
                        projected += income.balance
                        projected -= income.outstanding
                    }
                    bills.forEach{ bill in
                        if bill.nextDueDate < incomes[0].nextPayDate{
                            projected -= bill.amount
                        }
                    }
                }
                .onDisappear{
                    projected = 0.00
                }
            }
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color("Color2"), Color("Color1")]), startPoint: .leading, endPoint: .bottom))
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
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()
struct Overview_Previews: PreviewProvider {
    static var previews: some View {
        Overview().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
