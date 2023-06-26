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
        sortDescriptors: [NSSortDescriptor(keyPath: \Bill.nextDueDate, ascending: true)],
        animation: .default)
    private var bills: FetchedResults<Bill>

    @State var income: Income

    var body: some View {
        TabView{
            Group{
                Overview(income: $income)
                    .tabItem{ Label("Overview", systemImage: "banknote")}
                ContentView()
                    .tabItem { Label("Bills", systemImage: "list.dash")}
            }
            .toolbar(.visible, for: .tabBar).toolbarBackground(Color("Color2"), for: .tabBar)

        }
    }
}

