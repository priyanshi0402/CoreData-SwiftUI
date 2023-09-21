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
        guard let url = URL(string: url) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
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
    
    func fetchStateData(from url: String) async throws -> [[String: String]] {
        let filteredUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        guard let url = URL(string: filteredUrl) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7InVzZXJfZW1haWwiOiJwcml5YW5zaGliaGlrYWRpeWEuZGV2QGdtYWlsLmNvbSIsImFwaV90b2tlbiI6Im5xaXMzV01qbzZhUjhLNHhRNHVJZ2JWV3RwVlRucUtIaHNvcjBCTzVOZEU5enpnVDhIM2l6N1BSVVZMX0x0aThxclEifSwiZXhwIjoxNjk1MzY3MTIzfQ.GjSbrDIFrns-0HIJErFwWTiHGwMIc21KXXabr0kFuBs"]
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
