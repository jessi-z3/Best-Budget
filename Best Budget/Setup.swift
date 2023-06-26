//
//  Setup.swift
//  Best Budget
//
//  Created by Jessi Zimmerman on 6/22/23.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var available: Double = 0.00
    @State private var payDate: Date = Date.now.advanced(by: (14 * 86400))
    @State private var outstanding: Double = 0.00
    @State var frequency: Frequency = .biWeekly
    
    @Binding var setupComplete: Bool
    
    @Environment(\.presentationMode) var presentationMode
    var onDismiss: ((_ model: Bool) -> Void)?
    var onDismiss2: ((_ model: Income) -> Void)?

    @Binding var income: Income
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 35){
                    Text("Hi. Thanks for using Best Budget.").font(.title).bold()
                    Text("To get started, I'd like to ask you a few questions.")
                    HStack{
                        Text("When is your next pay date?")
                        Spacer()
                        DatePicker("", selection: $payDate, displayedComponents: [.date]).padding()
                    }
                    HStack{
                        Text("How often do you get paid?")
                        Spacer()
                        Picker("Frequency", selection: $frequency){
                            ForEach(Frequency.allCases){ freq in
                                Text(freq.rawValue.capitalized)
                            }.font(.title3)
                        }
                    }
                    HStack{
                        Text("What's your current balance?")
                        Spacer()
                        TextField(String(format: "$%.2f", available), value: $available, formatter: formatter)                     .textContentType(.oneTimeCode).textFieldStyle(.roundedBorder).frame(width: 150)
                    }
                    HStack{
                        Text("Do you have any outstanding charges?")
                        Spacer()
                        TextField(String(format: "$%.2f", outstanding), value: $outstanding, formatter: formatter)                     .textContentType(.oneTimeCode).textFieldStyle(.roundedBorder).frame(width: 150)
                    }
                    Spacer()
                    Text("Next, we'll move on to bills.")
                    Spacer()
                    HStack{
                        Spacer()
                        Button("Save"){
                            do{
                                income.nextPayDate = payDate
                                income.balance = available
                                income.payFrequency = frequency.rawValue
                                income.outstanding = outstanding
                                try viewContext.save()
                                setupComplete = true
                            } catch {
                                setupComplete = false
                                let nsError = error as NSError
                                print("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                            print(income)
                            onDismiss?(setupComplete)
                            onDismiss2?(income)
                            presentationMode.wrappedValue.dismiss()
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .accentColor(Color("Color2"))
            .foregroundStyle(Color("Color2"))
            .padding()
        }
    }
}

struct Setup: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var income: Income = Income()
    
    @State private var showingSheet = false
    @SceneStorage("Setup.setupComplete") var setupComplete: Bool = false
    
    public func createIncome() -> Income {
        let newIncome = Income(context: viewContext)
        newIncome.balance = 0.00
        newIncome.nextPayDate = Date()
        newIncome.outstanding = 0.00
        newIncome.payFrequency = Frequency.biWeekly.rawValue
        return newIncome
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Welcome").font(.largeTitle).foregroundStyle(Color.white).fontWeight(.bold)
                Spacer()
                if (!setupComplete){
                    Button("Begin Setup"){
                        showingSheet = true
                        income = createIncome()
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $showingSheet) {
                        SheetView(setupComplete: $setupComplete, income: $income)
                    }
                } else {
                    NavigationLink{
                        MainView(income: income)
                    }label: {
                        Text("View My Budget")
                    }
                    .buttonStyle(.borderedProminent)

                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fontWidth(.expanded).foregroundStyle(Color("Color2"))
            .background(LinearGradient(gradient: Gradient(colors: [Color("Color2"), Color("Color1")]), startPoint: .leading, endPoint: .bottom))
        }
    }
}

private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

