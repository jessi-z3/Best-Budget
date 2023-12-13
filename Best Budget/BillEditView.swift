//
//  BillEditView.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/19/23.
//

import SwiftUI

struct BillEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Income.nextPayDate, ascending: true)],
        animation: .default)
    var incomes: FetchedResults<Income>

    var bill: Bill
    @State var company = ""
    @State var category = ""
    @State var date = Date()
    @State var amount = 0.00
    @State var frequency: Frequency = .monthly
    @State var saved: Bool = false
    @Binding var projected: Double

    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                TextField(bill.company, text: $company).font(.largeTitle)
                TextField(bill.category, text: $category).font(.title)
                DatePicker("Due Date:", selection: $date, displayedComponents: .date).font(.title2).colorScheme(.dark).datePickerStyle(.automatic).accentColor(Color("Color2"))
                HStack{
                    Text("Amount:").font(.title3)
                    Spacer()
                    TextField(String(format: "$%.2f", bill.amount), value: $amount, formatter: formatter).foregroundStyle(Color("Color2"))                     .textContentType(.oneTimeCode).textFieldStyle(.roundedBorder).frame(width: 150)
                }
                HStack{
                    Text("Frequency:").font(.title3)
                    Spacer()
                    Picker("Frequency", selection: $frequency){
                        ForEach(Frequency.allCases){ freq in
                            Text(freq.description).tag(freq.description)
                        }.font(.title3)
                    }
                }
                Spacer()
                Button{
                    bill.nextDueDate = getNextDueDate(frequency: frequency, bill: bill)
                    date = bill.nextDueDate
                }label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 25).frame(width: 200, height: 50, alignment: .center)
                        Text("Mark as Paid")
                            .foregroundColor(.red).frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
        .padding()
        .fontWidth(.expanded).foregroundStyle(Color.white)

        .onAppear{
            company = bill.company
            category = bill.category
            date = bill.nextDueDate
            amount = bill.amount
            frequency = Frequency(rawValue: bill.frequency) ?? .monthly
        }
        .padding()
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button("Save"){
                    do{
                        print(bill)
                        bill.company = company
                        bill.category = category
                        bill.nextDueDate = date
                        bill.frequency = frequency.rawValue
                        bill.amount = amount
                        print(bill)
                        try viewContext.save()
                        saved = true
                        if bill.nextDueDate < incomes[0].nextPayDate{
                            projected -= bill.amount
                        }
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
        .background(LinearGradient(gradient: Gradient(colors: [Color("Color2"), Color("Color1")]), startPoint: .leading, endPoint: .bottom))
    }
}

private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

