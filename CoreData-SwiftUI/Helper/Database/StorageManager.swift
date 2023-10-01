//
//  StorageManager.swift
//  CoreData-SwiftUI
//
//  Created by SARVADHI on 26/09/23.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    func setToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "auth_token")
        UserDefaults.standard.synchronize()
    }
    
    var getToken: String {
        return UserDefaults.standard.string(forKey: "auth_token") ?? ""
    }
}
