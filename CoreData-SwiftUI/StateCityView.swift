//
//  StateCityView.swift
//  CoreData-SwiftUI
//
//  Created by SARVADHI on 20/09/23.
//

import SwiftUI

struct StateCityView: View {
    var body: some View {
        VStack {
            List {
                Text("Test")
                Text("Test1")
                Text("Test2")
                Text("Test3")
                Text("Test4")
                
            }
            .listStyle(.grouped)
        }
        .navigationBarTitle("State", displayMode: .inline)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        StateCityView()
    }
}
