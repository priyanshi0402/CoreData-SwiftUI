//
//  Network.swift
//  CoreData-SwiftUI
//
//  Created by SARVADHI on 21/09/23.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    
}

class APIManager {
    static let shared = APIManager()
    
    func fetchDatas<T: Decodable>(from url: String, responseType: [T].Type) async throws -> [T] {
        let filteredUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        guard let url = URL(string: filteredUrl) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(StorageManager.shared.getToken)"]
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw APIError.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(responseType, from: data)
            return decodedResponse
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
    
    func fetchToken() async throws -> String {
        guard let url = URL(string: "https://www.universal-tutorial.com/api/getaccesstoken") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["api-token": "nqis3WMjo6aR8K4xQ4uIgbVWtpVTnqKHhsor0BO5NdE9zzgT8H3iz7PRUVL_Lti8qrQ", "user-email": "priyanshibhikadiya.dev@gmail.com"]
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw APIError.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONSerialization.jsonObject(with: data) as? [String: String]
            return decodedResponse?["auth_token"] as? String ?? ""
        } catch {
            throw APIError.decodingFailed(error)
        }
        
    }
    
    func fetchStateData(from url: String) async throws -> [[String: String]] {
        let filteredUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        guard let url = URL(string: filteredUrl) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(StorageManager.shared.getToken)"]
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw APIError.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONSerialization.jsonObject(with: data) as? [[String: String]]
            return decodedResponse ?? [[:]]
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
    
    func storeStatesInCoreData(data: [[String: String]]) {
        for datum in data {
            let statesData = States(context: CoreDataHelper.shared.viewContext)
            statesData.stateName = datum["state_name"]
            CoreDataHelper.shared.saveData(statesData)
        }
    }
    
}
