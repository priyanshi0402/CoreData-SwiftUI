//
//  CoreData_SwiftUIApp.swift
//  CoreData-SwiftUI
//
//  Created by Priyanshi Bhikadiya on 19/09/23.
//

import SwiftUI

@main
struct CoreData_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
