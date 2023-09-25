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
    
    @State private var selectedState: String = "Select State"
    @State private var selectedCity: String = ""
    @State private var collegeName: String = ""
    @State private var universityName: String = ""
    @State private var isShowPicker = false
    @State private var isShowCityPicker = false
    var allStates = CoreDataHelper.shared.fetchData(type: States.self, entityName: "States")
    var citiesViewModel = CitiesViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("College Details")) {
                TextField("Enter college Name", text: $collegeName)
                if #available(iOS 16.0, *) {
                    Picker("State", selection: $selectedState) {
                        ForEach(allStates, id: \.stateName) {
                            Text($0.stateName ?? "")
                                .tag($0.stateName ?? "")
                        }
                    }
                    .onChange(of: selectedState, perform: { newValue in
                        Task {
                            await self.citiesViewModel.fetchCitiesData(from: newValue)
                        }
                    })
                    .pickerStyle(.navigationLink)
                } else {
                    CustomNavigationPicker(destinationView: StateCityView(allStates: allStates, selectedValue: $selectedState), selectedValue: $selectedState, isShowPicker: $isShowPicker, title: "State")
                        .onChange(of: selectedState) { newValue in
                            Task {
                                await self.citiesViewModel.fetchCitiesData(from: newValue)
                            }
                        }
                }
                
                if self.citiesViewModel.isLoading {
                    ProgressView()
                } else {
                    if #available(iOS 16.0, *) {
                        Picker("City", selection: $selectedCity) {
                            ForEach(self.citiesViewModel.citiesData, id: \.city_name) {
                                Text($0.city_name ?? "")
                                    .tag($0.city_name ?? "")
                            }
                        }
                        .pickerStyle(.navigationLink)
                    } else {
                        CustomNavigationPicker(destinationView: StateCityView(allcities: self.citiesViewModel.citiesData, isForCity: true, selectedValue: $selectedCity), selectedValue: $selectedCity, isShowPicker: $isShowCityPicker, title: "City")
                    }
                }
                TextField("Enter university Name", text: $universityName)
            }
            
            Section {
                HStack {
                    Spacer()
                    SaveButton(collegeName: self.collegeName, city: self.selectedCity, university: self.universityName)
                    Spacer()
                }
            }
            .frame(height: 40)
        }
        .navigationBarTitle("Form", displayMode: .inline)
        
    }
    
}

struct SaveButton: View {
    var collegeName: String = ""
    var city: String = ""
    var university: String = ""
    @State private var isShowAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        Button {
            if collegeName.isEmpty {
                self.alertMessage = "College name cannot be empty!"
                self.isShowAlert = true
                return
            }
            
            if city.isEmpty {
                self.alertMessage = "City cannot be empty!"
                self.isShowAlert = true
                return
            }
            
            if university.isEmpty {
                self.alertMessage = "University name cannot be empty!"
                self.isShowAlert = true
                return
            }
            let college = College(context: CoreDataHelper.shared.viewContext)
            college.id = UUID().uuidString
            college.name = self.collegeName
            college.city = self.city
            college.university = self.university
            CoreDataHelper.shared.saveData(college)
        } label: {
            Text("Save Data")
        }.alert(isPresented: $isShowAlert) {
            Alert.customAlert(title: "Error", message: self.alertMessage)
        }
    }
}

extension Alert {
    static func customAlert(title: String, message: String) -> Alert {
        return Alert(
            title: Text(title),
            message: Text(message),
            dismissButton: .cancel(Text("OK"))
        )
    }
}

struct CustomNavigationPicker<Destination: View>: View {
    
    var destinationView: Destination
    @Binding var selectedValue: String
    @Binding var isShowPicker: Bool
    var title: String
    
    var body: some View {
        NavigationLink(destination: destinationView , isActive: $isShowPicker) {
            Button {
                self.isShowPicker = true
            } label: {
                VStack {
                    HStack {
                        Text(title)
                            .foregroundColor(.black)
                        Spacer()
                        Text(self.selectedValue)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
        }
    }
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
