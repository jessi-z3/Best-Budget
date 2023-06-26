//
//  BillEditView.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/19/23.
//

import SwiftUI

struct BillEditView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var bill: Bill
    @State var company = ""
    @State var category = ""
    @State var date = Date()
    @State var amount = 0.00
    @State var frequency: Frequency = .monthly
    @State var saved: Bool = false

    var body: some View {
            VStack(alignment: .leading){
                TextField(bill.company, text: $company).font(.largeTitle)
                TextField(bill.category, text: $category).font(.title)
                DatePicker("Due Date:", selection: $date, displayedComponents: .date).font(.title2)
            HStack{
                Text("Amount:").font(.title3)
                Spacer()
                TextField("$" + String(format: "$%.2f", bill.amount), value: $amount, formatter: formatter).foregroundStyle(Color("Color2"))                     .textContentType(.oneTimeCode).textFieldStyle(.roundedBorder).frame(width: 150)
            }
            HStack{
                Text("Frequency:").font(.title3)
                Spacer()
                Picker("Frequency", selection: $frequency){
                    ForEach(Frequency.allCases){ freq in
                        Text(freq.rawValue.capitalized)
                    }.font(.title3)
                }
            }
            Spacer()
            Button{
                bill.nextDueDate = getNextDueDate(frequency: frequency, bill: bill)
                date = bill.nextDueDate
            }label: {
                Text("Mark as Paid")
                    .foregroundColor(.red).frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding()
        .fontWidth(.expanded).foregroundStyle(Color("Color2"))

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
}

private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

