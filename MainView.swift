//
//  MainView.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/20/23.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Income.nextPayDate, ascending: true)],
        animation: .default)
    private var incomes: FetchedResults<Income>
    @State var setupComplete: Bool = false
    @Binding var projected: Double

    public func createIncome() -> Income {
        let newIncome = Income.init(context: viewContext)
        newIncome.balance = 0.00
        newIncome.nextPayDate = Date()
        newIncome.outstanding = 0.00
        newIncome.payFrequency = Frequency.weekly.description
        if viewContext.hasChanges{
            try? viewContext.save()
        }
        return newIncome
    }
    var body: some View {
        TabView{
            Overview(projected: $projected)
                .tabItem{ Label("Overview", systemImage: "banknote")}
            ContentView(projected: $projected)
                .tabItem { Label("Bills", systemImage: "list.dash")}
            SheetView(setupComplete: $setupComplete, projected: $projected)
                .tabItem { Label("Setup", systemImage: "gearshape.fill")}

        }
        .edgesIgnoringSafeArea(.vertical)
        .onAppear(){
            UITabBar.appearance().backgroundColor = UIColor(Color("Color2"))
            UITabBar.appearance().unselectedItemTintColor = UIColor(Color("Color1"))
            UITabBar.appearance().tintColor = UIColor(Color("Color2"))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    @State static var projected: Double = 0.00

    static var previews: some View {
        MainView(projected: $projected).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
