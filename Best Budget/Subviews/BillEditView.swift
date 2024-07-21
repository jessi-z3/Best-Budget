//
//  BillEditView.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/19/23.
//

import SwiftUI
import SwiftData
import CloudKit

struct BillEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    var bill: Bill
    @State var company = ""
    @State var category = ""
    @State var date = Date()
    @State var amount = 0.00
    @State var frequency: Frequency = .monthly
    @State var saved: Bool = false
    let record = CKRecord(recordType: "Bill")

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading){
                TextField(bill.company, text: $company).font(.largeTitle)
                TextField(bill.category, text: $category).font(.title)
                DatePicker("Due Date:", selection: $date, displayedComponents: .date).font(.title2)
                HStack {
                    Text("Amount:").font(.title3)
                    Spacer()
                    TextField("$" + String(format: "$%.2f", bill.amount), value: $amount, formatter: formatter)
                        .foregroundStyle(Color("Color2"))
                        .textContentType(.oneTimeCode).textFieldStyle(.roundedBorder).frame(width: 150)
                }
                HStack {
                    Text("Frequency:").font(.title3)
                    Spacer()
                    Picker("Frequency", selection: $frequency) {
                        ForEach(Frequency.allCases){ freq in
                            Text(freq.rawValue.capitalized)
                        }.font(.title3)
                    }
                }
                Spacer()
                HStack {
                    Button {
                        bill.nextDueDate = getNextDueDate(frequency: frequency, bill: bill)
                        date = bill.nextDueDate
                    } label: {
                        Text("Mark as Paid")
                    }
                    Spacer()
                    Button {
                        deleteBill(bill: bill)
                    } label: {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .fontWidth(.expanded)
        .foregroundStyle(Color.white)
        
        .onAppear {
            company = bill.company
            category = bill.category
            date = bill.nextDueDate
            amount = bill.amount
            frequency = bill.frequency
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save"){
                    Task {
                        await addBill(newBill: bill)
                        saved = true
                    }
                }
                .alert("Success", isPresented: $saved) {
                    Button("OK", role: .cancel){}
                }
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color("Color2"), Color("Color1")]), startPoint: .leading, endPoint: .bottom))
    }
    private func addBill(newBill: Bill) async {
        let container = CKContainer.default()
        let database = container.privateCloudDatabase
            Task {
                do {
                    newBill.company = company
                    newBill.category = category
                    newBill.nextDueDate = date
                    newBill.amount = amount
                    newBill.frequency = frequency
                    
                    record.setValuesForKeys([
                        "company": newBill.company,
                        "category": newBill.category,
                        "dueDate": newBill.nextDueDate.description,
                        "amount": newBill.amount,
                        "frequency": newBill.frequency.rawValue
                    ])
                    
                    modelContext.insert(newBill)
                    try modelContext.save()
                    try await database.save(record)
                } catch {
                    let nsError = error as NSError
                    print("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        
    }
    
    private func deleteBill(bill: Bill) {
        withAnimation {
            modelContext.delete(bill)
            do {
                try modelContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
                dismiss()
        }
    }
}

public let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}()

