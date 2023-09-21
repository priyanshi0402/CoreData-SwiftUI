//
//  ContentView.swift
//  CoreData-SwiftUI
//
//  Created by Priyanshi Bhikadiya on 19/09/23.
//

import SwiftUI
import CoreData

final class AppRootManager: ObservableObject {
    @Published var currentRoot: RootView = .splash
    
    enum RootView {
        case splash
        case home
    }
}

struct CollegeFromView: View {

    @State private var selectedCategory: String = "Test"
    @State private var collegeName: String = "Test"
    @State private var isShowPicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("State", selection: $selectedCategory) {
                        Text("Test")
                        Text("Test1")
                        Text("Test2")
                        Text("Test3")
                        Text("Test4")
                    }
                } header: {
                    Text("Suggested Course")
                }
                
                if #available(iOS 16.0, *) {
                    Picker("City", selection: $selectedCategory) {
                        Text("Test")
                        Text("Test1")
                        Text("Test2")
                        Text("Test3")
                        Text("Test4")
                        Text("Test5")
                        Text("Test6")
                    }
                    .pickerStyle(.navigationLink)
                } else {
                    NavigationLink(destination: StateCityView(), isActive: $isShowPicker) {
                        Button {
                            self.isShowPicker = true
                        } label: {
                            VStack {
                                HStack {
                                    Text("State")
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text(self.selectedCategory)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                    }
                    
                }
                
                Picker("State", selection: $selectedCategory) {
                    Text("Test")
                    Text("Test1")
                    Text("Test2")
                    Text("Test3")
                    Text("Test4")
                }
                
                Button {
                    let college = College(context: CoreDataHelper.shared.viewContext)
                    college.id = UUID().uuidString
                    college.name = "SD Jain College"
                    college.city = "Surat"
                    college.university = "Veer nermad gujarat universiy"
                    CoreDataHelper.shared.saveData(college)
                } label: {
                    Text("Save Data")
                }
            }
            .navigationTitle("College")
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CollegeFromView()
    }
}
