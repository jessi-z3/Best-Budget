//
//  Persistence.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/19/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newBill = Bill(context: viewContext)
            newBill.nextDueDate = Date()
            newBill.amount = 1550.65
            newBill.category = "Home"
            newBill.frequency = Frequency.monthly.rawValue
            newBill.company = "Mortgage Bank"
            
        }
        let newIncome = Income(context: viewContext)
        newIncome.balance = 0.00
        newIncome.nextPayDate = Date()
        newIncome.outstanding = 0.00
        newIncome.payFrequency = Frequency.biWeekly.rawValue
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Best_Budget")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
