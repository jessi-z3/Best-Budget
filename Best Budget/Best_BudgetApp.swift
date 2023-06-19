//
//  Best_BudgetApp.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/19/23.
//

import SwiftUI

@main
struct Best_BudgetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
