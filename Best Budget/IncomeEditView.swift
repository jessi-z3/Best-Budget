//
//  IncomeEditView.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 8/17/23.
//

import SwiftUI

struct IncomeEditView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var incomeName: String = "Income Name"
    @State private var available: Double = 0.00
    @State private var payDate: Date = Date().startOfHour()
    @State private var outstanding: Double = 0.00
    @State var frequency: Frequency = .weekly
    @State var saved: Bool = false
    @Binding var setupComplete: Bool
    @Binding var projected : Double
    var income: Income
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text("Paid From: ")
                    Spacer()
                    TextField(income.incomeName, text: $incomeName).textFieldStyle(.roundedBorder).frame(width: 200).foregroundStyle(Color("Color2"))
                }
                HStack{
                    Text("Next Pay Date: ")
                    Spacer()
                    DatePicker("", selection: $payDate, displayedComponents: [.date]).colorScheme(.dark)
                        .datePickerStyle(.automatic).accentColor(Color("Color2"))
                        .onSubmit {
                            income.nextPayDate = payDate
                        }
                }
                HStack{
                    Text("Pay Frequency: ")
                    Spacer()
                    Picker("Frequency", selection: $frequency){
                        ForEach(Frequency.allCases){ freq in
                            Text(freq.description).tag(freq.description)
                        }.font(.title3)
                    }
                    .onSubmit {
                        frequency = Frequency(rawValue: income.payFrequency) ?? .monthly
                    }
                    
                }
                HStack{
                    Text("Current Balance: ")
                    Spacer()
                    TextField(String(format: "$%.2f", available), value: $available, formatter: formatter)
                        .foregroundStyle(Color("Color2"))
                        .textContentType(.oneTimeCode).textFieldStyle(.roundedBorder).frame(width: 100)
                }
                HStack{
                    Text("Outstanding: ")
                    Spacer()
                    TextField(String(format: "$%.2f", outstanding), value: $outstanding, formatter: formatter).foregroundStyle(Color("Color2")) .textContentType(.oneTimeCode).textFieldStyle(.roundedBorder).frame(width: 100)
                }
                Spacer()
                Button{
                    income.nextPayDate = getNextPayDate(frequency: frequency, income: income)
                    payDate = income.nextPayDate
                }label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 25).frame(width: 200, height: 50, alignment: .center)
                        Text("I Got Paid")
                            .foregroundColor(.red).frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .onAppear{
                    payDate = income.nextPayDate.startOfHour()
                    available = income.balance
                    frequency = Frequency(rawValue: income.payFrequency) ?? .weekly
                    outstanding = income.outstanding
                    incomeName = income.incomeName
                }
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Button("Save"){
                            do{
                                income.nextPayDate = payDate.startOfHour()
                                income.balance = available
                                income.payFrequency = frequency.rawValue
                                income.outstanding = outstanding
                                income.incomeName = incomeName
                                try viewContext.save()
                                saved = true
                                setupComplete = true
                                
                                projected += income.balance
                                projected -= income.outstanding
                                
                            } catch {
                                saved = false
                                let nsError = error as NSError
                                print("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }.alert("Success", isPresented: $saved){
                            Button("OK", role: .cancel){}
                        }
                    }
                }
            }
            .fontWidth(.expanded)
            .frame(maxHeight: .infinity)
            .foregroundStyle(Color.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color("Color2"), Color("Color1")]), startPoint: .leading, endPoint: .bottom))
        }
    }
}
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()
private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

