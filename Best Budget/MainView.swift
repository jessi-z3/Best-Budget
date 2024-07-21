//
//  MainView.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/20/23.
//

import SwiftUI
import SwiftData
import CloudKit

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) var scenePhase
    @Query(sort: \Bill.nextDueDate) var bills: [Bill]
    @Query(sort: \Income.nextPayDate) var incomes: [Income]
    @State var signedIn = false

    var body: some View {
        TabView {
            Group {
                Overview(signedIn: $signedIn)
                    .tabItem { Label("Overview", systemImage: "banknote")}
                BillsView()
                    .tabItem { Label("Bills", systemImage: "list.dash")}
                IncomesView()
                    .tabItem { Label("Incomes", systemImage: "building.columns.fill")}
            }
            .toolbar(.visible, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .accentColor(.white)
        }
        .onAppear{
                    checkAccountStatus()
                }
                .onChange(of: scenePhase, checkAccountStatus)
    }
    func checkAccountStatus() {
                CKContainer.default().accountStatus { status, error in
                  DispatchQueue.main.async {
                    switch status {
                    case .available:
                       signedIn = true
                    default:
                       signedIn = false
                    }
                    if let error = error {
                        print(error)
                    }
                  }
                }
            }
}

#Preview {
    MainView()
}
