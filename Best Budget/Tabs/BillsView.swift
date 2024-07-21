//
//  ContentView.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/19/23.
//

import SwiftUI
import SwiftData

struct BillsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Bill.nextDueDate) var bills: [Bill]
    var body: some View {
        NavigationStack {
            ScrollView {
                if bills.isEmpty {
                    
                    Rectangle()
                        .foregroundStyle(.placeholder)
                    
                }
                ForEach(bills) { bill in
                    NavigationLink {
                        BillEditView(bill: bill)
                    } label: {
                        HStack {
                            Text(bill.company)
                            Spacer()
                            Text(bill.nextDueDate, formatter: itemFormatter)
                        }
                        .foregroundStyle(Color.white)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Bills")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                }
                ToolbarItem {
                    NavigationLink {
                        BillEditView(bill: Bill(
                            amount: 0.00,
                            category: "Category",
                            company: "Company Name",
                            frequency: Frequency.monthly,
                            nextDueDate: Date()
                        ))
                    } label: {
                        Label("Add Bill", systemImage: "plus")
                    }
                }
            }
            .fontWidth(.expanded)
            .padding()
            .frame(alignment: .center)
            .background(LinearGradient(gradient: Gradient(colors: [Color("Color2"), Color("Color1")]), startPoint: .leading, endPoint: .bottom))
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.locale = Locale(identifier: "en_US")
    formatter.setLocalizedDateFormatFromTemplate("MMMMd")
    return formatter
}()

#Preview {
    BillsView()
}
