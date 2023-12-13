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
    @Binding var projected : Double
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15){
                HStack{
                    Text("Bills").font(.largeTitle).fontWeight(.bold).foregroundStyle(Color.white)
                        .padding(15)

                    Spacer()
                    EditButton().font(.title2).fontWeight(.bold).foregroundStyle(Color.white)
                    Button(action: addItem) {
                        Label("", systemImage: "plus").font(.title2).fontWeight(.bold).foregroundStyle(Color.white)
                    }
                    .padding(7)
                }
                
                List {
                    ForEach(bills) { bill in
                        NavigationLink {
                            BillEditView(bill: bill, projected: $projected)
                        } label: {
                            HStack{
                                Text(bill.company)
                                Spacer()
                                Text(bill.nextDueDate, formatter: itemFormatter)
                            }
                            .foregroundStyle(Color("Color2"))
                        }
                    }
                    .onDelete(perform: deleteItems)
                    
                }
                .scrollContentBackground(.hidden)
                                
            }
            .fontWidth(.expanded).frame( alignment: .center)
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color("Color2"), Color("Color1")]), startPoint: .leading, endPoint: .bottom))
        }
        
    }
    private func addItem() {
        withAnimation {
            let newBill = Bill(context: viewContext)
            newBill.nextDueDate = Date().startOfHour() 
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
    formatter.timeStyle = .none
    formatter.locale = Locale(identifier: "en_US")
    formatter.setLocalizedDateFormatFromTemplate("MMMMd")
    return formatter
}()
extension Date {

    func startOfHour() -> Date
    {
        let calendar = Calendar.current

        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        
        components.hour = 0
        components.minute = 0
        components.second = 0

        return calendar.date(from: components) ?? Date()
    }

}
struct ContentView_Previews: PreviewProvider {
    @State static var projected: Double = 0.00

    static var previews: some View {
        ContentView(projected: $projected).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
