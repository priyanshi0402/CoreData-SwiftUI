//
//  StateCityView.swift
//  CoreData-SwiftUI
//
//  Created by SARVADHI on 20/09/23.
//

import SwiftUI

struct StateCityView: View {
    
    var allStates: [States] = []
    var allcities: [Cities] = []
    var isForCity: Bool = false
    @Binding var selectedValue: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            if isForCity {
                List {
                    ForEach(allcities, id: \.city_name) { city in
                        Text(city.city_name ?? "")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                self.selectedValue = city.city_name ?? ""
                                self.presentationMode.wrappedValue.dismiss()
                                print(city.city_name ?? "")
                            }
                    }
                    
                }
                .listStyle(.grouped)
                
            } else {
                List {
                    ForEach(allStates) { state in
                        Text(state.stateName ?? "")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                self.selectedValue = state.stateName ?? ""
                                self.presentationMode.wrappedValue.dismiss()
                                print(state.stateName ?? "")
                            }
                    }
                    
                }
                .listStyle(.grouped)
            }
           
        }
        .navigationBarTitle(isForCity ? "Cities" : "State", displayMode: .inline)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
     static var previews: some View {
         StateCityView(selectedValue: .constant("California"))
    }
}
