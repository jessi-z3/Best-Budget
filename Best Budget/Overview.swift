//
//  Overview.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/21/23.
//

import SwiftUI

struct Overview: View {
    enum Field {
        case balance
        case outstanding
    }
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Bill.nextDueDate, ascending: true)],
        animation: .default)
    var bills: FetchedResults<Bill>
    

    @State var projected: Double = 0.00
    
    @FocusState private var focusedField: Field?
    
    @State var saved: Bool = false
    @State var date = Date()

    @Binding var income: Income
    @State var frequency : Frequency = .biWeekly

    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20){
                
                Text("Overview").font(.largeTitle).fontWeight(.bold).foregroundStyle(Color.white)
                Spacer()
                HStack{
                    Text("Balance:").fontWeight(.bold).font(.title2).foregroundStyle(Color.white)
                    Spacer()
                    TextField(String(format: "$%.2f", income.balance), value: $income.balance, formatter: formatter)
                        .focused($focusedField, equals: .balance)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.oneTimeCode)
                        .frame(maxWidth: 150).font(.title3)
                        .foregroundStyle(Color("Color2"))
                        .onSubmit {
                            projected = income.balance
                            projected -= income.outstanding
                            bills.forEach{ bill in
                                if bill.nextDueDate <= income.nextPayDate{
                                    projected -= bill.amount
                                }
                            }
                        }
                    }
                    HStack{
                        Text("Pay Date:").fontWeight(.bold).font(.title2).foregroundStyle(Color.white)
                        Spacer()
                        DatePicker("", selection: $date, displayedComponents: [.date]).colorScheme(.dark)
                            .onChange(of: date) {
                                projected = income.balance
                                projected -= income.outstanding
                                bills.forEach{ bill in
                                    if bill.nextDueDate <= income.nextPayDate{
                                        projected -= bill.amount
                                    }
                                }
                            }
                        }
                HStack(alignment: .center){
                    Text("Paid: ").foregroundStyle(Color.white)
                    Picker("Frequency", selection: $frequency, content: {
                        ForEach(Frequency.allCases, content: { freq in
                            Text(String(String(describing: freq)))
                        })
                        .font(.title3)
                    })
                    Spacer()
                    Button{
                        income.nextPayDate = getNextPayDate(frequency: frequency, income: income)
                        date = income.nextPayDate
                    }label: {
                        Text("Next Pay Date").foregroundStyle(Color("Color1"))
                    }
                }
                .padding()
                Text("Bills this period:")
                    .fontWeight(.bold)
                    .font(.title2)
                    .foregroundStyle(Color.white)
                ForEach(bills){ bill in
                    HStack{
                        if bill.nextDueDate <= income.nextPayDate{
                            Text(bill.company)
                                .foregroundStyle(Color.white)
                            Spacer()
                            Text(String(format: "$%.2f", bill.amount))
                                .foregroundStyle(Color.white)
                        }
                    }
                }
                HStack{
                    Text("Outstanding:").fontWeight(.bold).font(.title2).foregroundStyle(Color.white)
                    Spacer()
                    TextField(String(format: "$%.2f", income.outstanding), value: $income.outstanding, formatter: formatter)
                        .focused($focusedField, equals: .outstanding)
                        .textContentType(.oneTimeCode)
                        .foregroundStyle(Color("Color2"))
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 150)
                        .font(.title3)
                        .onSubmit {
                            projected = income.balance
                            projected -= income.outstanding
                            bills.forEach{ bill in
                                if bill.nextDueDate <= income.nextPayDate{
                                    projected -= bill.amount
                                }
                            }
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
                            .foregroundStyle(Color("Color2"))
                    }
                }
                .onSubmit {
                    switch focusedField {
                    case .balance:
                        focusedField = .balance;
                    case .outstanding:
                        focusedField = .outstanding;
                    default:
                        print("fields completed")
                    }
                }
                .fontWidth(.expanded)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .onAppear{
                    frequency = Frequency(rawValue: income.payFrequency)!
                    projected = income.balance
                    bills.forEach{ bill in
                        if bill.nextDueDate <= income.nextPayDate{
                            projected -= bill.amount
                        }
                    }
                    projected -= income.outstanding
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
