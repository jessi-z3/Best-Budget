//
//  Setup.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/22/23.
//

import SwiftUI
import CoreData

struct SheetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var setupComplete: Bool
    @Binding var projected: Double
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Income.nextPayDate, ascending: true)],
        animation: .default)
    private var incomes: FetchedResults<Income>
    var body: some View {
        NavigationStack{
                VStack(alignment: .leading, spacing: 15){
                    HStack{
                        Text("Incomes").font(.largeTitle).fontWeight(.bold)
                            .padding(15)

                        Spacer()
                        EditButton().font(.title2).fontWeight(.bold).foregroundStyle(Color.white)
                        Button(action: createIncome) {
                            Label("", systemImage: "plus").font(.title2).fontWeight(.bold).foregroundStyle(Color.white)
                        }
                        .padding(7)
                    }
                    List{
                        ForEach(incomes){ income in
                            NavigationLink{
                                IncomeEditView(setupComplete: $setupComplete, projected: $projected, income: income)
                            }label: {
                                HStack{
                                    Text(income.incomeName)
                                }

                            }.foregroundStyle(Color("Color2"))
                        }.onDelete(perform: deleteIncome)
                    }
                    
                    .scrollContentBackground(.hidden)
                    Spacer()
                }
                .fontWidth(.expanded)
                .frame(alignment: .center)
                .foregroundStyle(Color.white)
                .padding(10)
                .background(LinearGradient(gradient: Gradient(colors: [Color("Color2"), Color("Color1")]), startPoint: .leading, endPoint: .bottom))
            }
            
            
        }
    private func deleteIncome(offsets: IndexSet) {
        withAnimation {
            offsets.map { incomes[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    public func createIncome() {
        withAnimation {
            let newIncome = Income(context: viewContext)
            newIncome.incomeName = "Income Name"
            newIncome.balance = 0.00
            newIncome.nextPayDate = Date().startOfHour()
            newIncome.outstanding = 0.00
            newIncome.payFrequency = Frequency.weekly.description
            do{
                try viewContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")            }
        }

    }
    
}


struct Setup: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showingSheet = false
    @AppStorage("setupComplete") var setupComplete: Bool = false
    @AppStorage("projected") var projected: Double = 0.00

    var body: some View {
        NavigationStack{
            if (!setupComplete){
                VStack{
                    Text("Welcome").font(.largeTitle).foregroundStyle(Color.white).fontWeight(.bold).padding(.top)
                    Spacer()
                    Button("Begin Setup"){
                        showingSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $showingSheet) {
                        SheetView(setupComplete: $setupComplete, projected: $projected)
                    }
                    Spacer()
                }.padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .fontWidth(.expanded).foregroundStyle(Color("Color2"))
                    .background(LinearGradient(gradient: Gradient(colors: [Color("Color2"), Color("Color1")]), startPoint: .leading, endPoint: .bottom))
            } else {
                MainView(projected: $projected)
            }
        }
    }
}

struct Setup_Previews: PreviewProvider {
    static var previews: some View {
        Setup().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
