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
            newBill.nextDueDate = Date().startOfHour()
            newBill.amount = 0.00
            newBill.category = "Category"
            newBill.frequency = Frequency.monthly.rawValue
            newBill.company = "Company Name"
            
        }
        for _ in 0..<2 {
            let newIncome = Income(context: viewContext)
            newIncome.incomeName = "Income Name"
            newIncome.balance = 100.00
            newIncome.nextPayDate = Date().startOfHour()
            newIncome.outstanding = 50.00
            newIncome.payFrequency = Frequency.biWeekly.description
        }
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

