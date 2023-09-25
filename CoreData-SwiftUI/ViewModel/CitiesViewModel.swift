//
//  CitiesViewModel.swift
//  CoreData-SwiftUI
//
//  Created by SARVADHI on 23/09/23.
//

import Foundation

class CitiesViewModel: ObservableObject {
    @Published var citiesData: [Cities] = []
    @Published var isLoading = false

    func fetchCitiesData(from state: String) async {
        isLoading = true
        do {
            let data = try await APIManager.shared.fetchDatas(from: "https://www.universal-tutorial.com/api/cities/\(state)", responseType: [Cities].self)
            DispatchQueue.main.async {
                self.isLoading = false
                self.citiesData = data
            }
        } catch {
            self.isLoading = false 
            print(error)
        }
    }
}
