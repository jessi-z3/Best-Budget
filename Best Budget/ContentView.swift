//
//  ContentView.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/19/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Bill.nextDueDate, ascending: true)],
        animation: .default)
    private var bills: FetchedResults<Bill>

    var body: some View {
            NavigationView {
                List {
                    ForEach(bills) { bill in
                        NavigationLink {
                            BillEditView(bill: bill)
                        } label: {
                            HStack{
                                Text(bill.company)
                                Spacer()
                                Text(bill.nextDueDate, formatter: itemFormatter)
                            }.foregroundStyle(Color("Color2"))
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading){
                            Text("Bills").font(.largeTitle).fontWeight(.bold).foregroundStyle(Color("Color2"))
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            EditButton().foregroundStyle(Color("Color2"))
                        }
                        ToolbarItem {
                            Button(action: addItem) {
                                Label("Add Bill", systemImage: "plus")
                            }
                        }
                    }
                    .listStyle(.inset)
                
            }.fontWidth(.expanded).accentColor(Color("Color2")).padding().frame( alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: [Color("Color2"), Color("Color1")]), startPoint: .leading, endPoint: .bottom))
    }
    private func addItem() {
        withAnimation {
            let newBill = Bill(context: viewContext)
            newBill.nextDueDate = Date()
            newBill.amount = 0.00
            newBill.category = "Category"
            newBill.frequency = Frequency.monthly.rawValue
            newBill.company = "Company Name"
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { bills[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
