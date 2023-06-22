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
    private var bills: FetchedResults<Bill>
    @State private var available: Double = 100.66
    @State private var payDate: Date = Date.now.advanced(by: (14 * 86400))
    @State private var projected: Double = 0.00
    @State private var outstanding: Double = 0.00

    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20){
                Text("Overview").font(.largeTitle).fontWeight(.bold).foregroundStyle(Color.white)
                Spacer()
                HStack{
                    Text("Balance:").fontWeight(.bold).font(.title2).foregroundStyle(Color.white)
                    Spacer()
                    TextField(String(format: "$%.2f", available), value: $available, formatter: formatter).textFieldStyle(.roundedBorder).keyboardType(.decimalPad).frame(maxWidth: 150).font(.title3).foregroundStyle(Color("Color2")).onSubmit {
                        projected = available
                        projected -= outstanding
                        bills.forEach{ bill in
                            if bill.nextDueDate <= payDate{
                                projected -= bill.amount
                            }
                        }
                    }
                }
                HStack{
                    Text("Pay Date:").fontWeight(.bold).font(.title2).foregroundStyle(Color.white)
                    Spacer()
                    DatePicker("", selection: $payDate, displayedComponents: [.date]).colorScheme(.dark)
                        .onChange(of: payDate) {
                        projected = available
                        projected -= outstanding
                        bills.forEach{ bill in
                            if bill.nextDueDate <= payDate{
                                projected -= bill.amount
                            }
                        }
                    }
                }
                Text("Bills this period:").fontWeight(.bold).font(.title2).foregroundStyle(Color.white)
                ForEach(bills){ bill in
                    HStack{
                        if bill.nextDueDate <= payDate{
                            Text(bill.company).foregroundStyle(Color.white)
                            Spacer()
                            Text(String(format: "$%.2f", bill.amount)).foregroundStyle(Color.white)
                        }
                    }
                }
                HStack{
                    Text("Outstanding:").fontWeight(.bold).font(.title2).foregroundStyle(Color.white)
                    Spacer()
                    TextField(String(format: "$%.2f", outstanding), value: $outstanding, formatter: formatter).foregroundStyle(Color("Color2")).textFieldStyle(.roundedBorder).frame(maxWidth: 150).font(.title3).onSubmit {
                        projected = available
                        projected -= outstanding
                        bills.forEach{ bill in
                            if bill.nextDueDate <= payDate{
                                projected -= bill.amount
                            }
                        }
                    }
                }
                HStack{
                    Text("Projected Balance:").fontWeight(.bold).font(.title2).foregroundStyle(Color.white)
                    Spacer()
                    Text(String(format: "$%.2f", projected)).font(.title2).foregroundStyle(Color("Color2"))
                }
            }.fontWidth(.expanded).frame(maxWidth: .infinity, alignment: .leading).padding()
                .onAppear{
                    projected = available
                    bills.forEach{ bill in
                        if bill.nextDueDate <= payDate{
                            projected -= bill.amount
                        }
                    }
                }
                
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color("Color2"), Color("Color1")]), startPoint: .leading, endPoint: .bottom))
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
    return formatter
}()
#Preview {
    Overview()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
