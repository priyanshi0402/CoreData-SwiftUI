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
    @StateObject private var appRootManager = AppRootManager()

    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .splash:
                    SplashScreenView()
                case .home:
                    CollegeListView()
                }
            }
            .environmentObject(appRootManager)
        }
    }
}
