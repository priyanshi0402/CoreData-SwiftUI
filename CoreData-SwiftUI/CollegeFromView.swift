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
//    @State private var text = ""
    @State private var selectedCity: String = ""
    @State private var collegeName: String = ""
    @State private var universityName: String = ""
    @State private var isShowPicker = false
    @State private var isShowCityPicker = false
    var allStates = CoreDataHelper.shared.fetchData(type: States.self, entityName: "States")
    @ObservedObject var citiesViewModel = CitiesViewModel()
    var isForView: Bool = false
    var college: College? = nil
    
    var body: some View {
        Form {
            Section(header: Text("College Details")) {
                CustomTextField(bindingText: $collegeName, mode: isForView ? .view : .add, text: self.college?.name ?? "", placeHolder: "Enter college Name")
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
                
                if #available(iOS 16.0, *) {
                    Picker("City", selection: $selectedCity) {
                        ForEach(self.citiesViewModel.citiesData, id: \.city_name) {
                            Text($0.city_name ?? "")
                                .tag($0.city_name ?? "")
                        }
                    }
                    .disabled(self.citiesViewModel.citiesData.isEmpty)
                    .pickerStyle(.navigationLink)
                } else {
                    CustomNavigationPicker(destinationView: StateCityView(allcities: self.citiesViewModel.citiesData, isForCity: true, selectedValue: $selectedCity), selectedValue: $selectedCity, isShowPicker: $isShowCityPicker, title: "City")
                }
                CustomTextField(bindingText: $universityName, mode: isForView ? .view : .add, text: self.college?.name ?? "", placeHolder: "Enter university Name")
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

struct CustomTextField: View {
    @Binding var bindingText: String
    @State var mode: Mode = .add
    var text = ""
    var placeHolder: String
    
    var body: some View {
        switch mode {
        case .view:
            Text(text)
        case .edit:
            TextField(placeHolder, text: $bindingText)
        case .add:
            TextField(placeHolder, text: $bindingText)
        }
    }
}

struct SaveButton: View {
    var collegeName: String = ""
    var city: String = ""
    var university: String = ""
    @State private var isShowAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
            presentationMode.wrappedValue.dismiss()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CollegeFromView()
    }
}
