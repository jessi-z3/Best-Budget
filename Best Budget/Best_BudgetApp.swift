//
//  Best_BudgetApp.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/19/23.
//

import SwiftUI
import SwiftData

@main
struct Best_BudgetApp: App {
    let modelContainer: ModelContainer
        
        init() {
            do {
                modelContainer = try ModelContainer(for: Income.self, Bill.self)
            } catch {
                fatalError("Could not initialize ModelContainer")
            }
        }
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(modelContainer)
        }
    }
}
