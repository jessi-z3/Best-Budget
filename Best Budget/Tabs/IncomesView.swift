//
//  Setup.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/22/23.
//

import SwiftUI
import SwiftData

struct IncomesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Income.nextPayDate) var incomes: [Income]
    var body: some View {
        NavigationStack {
            ScrollView {
                if incomes.isEmpty {
                    Rectangle()
                        .foregroundStyle(.placeholder)
                }
                ForEach(incomes) { income in
                    NavigationLink {
                        IncomeEditView(income: income)
                    } label: {
                        HStack {
                            Text(income.source)
                            Spacer()
                            Text(String(format: "$%.2f", income.balance))
                        }
                        .foregroundStyle(Color.white)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Income")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                }
                ToolbarItem {
                    NavigationLink {
                        IncomeEditView(
                            income: Income(
                                source: "Source",
                                balance: 0,
                                nextPayDate: .now,
                                outstanding: 0,
                                payFrequency: .biWeekly)
                        )
                    } label: {
                        Label("Add Income", systemImage: "plus")
                    }
                }
            }
            .fontWidth(.expanded)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color("Color2"), Color("Color1")]), startPoint: .leading, endPoint: .bottom))
        }
    }
}


#Preview {
    IncomesView()
}
