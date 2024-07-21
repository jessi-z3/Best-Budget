//
//  SwiftUIView.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 7/11/24.
//

import SwiftUI
import SwiftData
import CloudKit

struct IncomeEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    var income: Income
    @State var source: String = ""
    @State var available: Double = 0.00
    @State var payDate: Date = Date.now.advanced(by: (14 * 86400))
    @State var outstanding: Double = 0.00
    @State var frequency: Frequency = .biWeekly
    @State var saved: Bool = false
    let record = CKRecord(recordType: "Income")
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading){
                TextField(income.source, text: $source).font(.largeTitle)
                DatePicker("Next Pay Date:", selection: $payDate, displayedComponents: .date).font(.title2)
                HStack {
                    Text("Balance:").font(.title3)
                    Spacer()
                    TextField("$" + String(format: "$%.2f", income.balance), value: $available, formatter: formatter)
                        .foregroundStyle(Color("Color2"))                     .textContentType(.oneTimeCode).textFieldStyle(.roundedBorder).frame(width: 150)
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
                        income.nextPayDate = getNextPayDate(frequency: frequency, income: income)
                        payDate = income.nextPayDate
                    } label: {
                        Text("I Got Paid")
                    }
                    Spacer()
                    Button {
                        deleteIncome(income: income)
                    } label: {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .fontWidth(.expanded)
        .foregroundStyle(Color.white)
        
        .onAppear{
            source = income.source
            available = income.balance
            payDate = income.nextPayDate
            frequency = income.payFrequency
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save"){
                    Task {
                        await addIncome(newIncome: income)
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
    private func addIncome(newIncome: Income) async {
        let container = CKContainer.default()
        let database = container.privateCloudDatabase
        Task {
            do {
                newIncome.source = source
                newIncome.balance = available
                newIncome.nextPayDate = payDate
                newIncome.payFrequency = frequency
                
                record.setValuesForKeys([
                    "source": newIncome.source,
                    "balance": newIncome.balance,
                    "nextPayDate": newIncome.nextPayDate.description,
                    "payFrequency": newIncome.payFrequency.rawValue
                ])
                
                modelContext.insert(newIncome)
                try modelContext.save()
                try await database.save(record)
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
    }
    private func deleteIncome(income: Income) {
        withAnimation {
            modelContext.delete(income)
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
#Preview {
    IncomeEditView(income: Income(source: "Jessi", balance: 0.00, nextPayDate: Date(), outstanding: 0.00, payFrequency: Frequency.biWeekly))
}
