//
//  CollegeListView.swift
//  CoreData-SwiftUI
//
//  Created by SARVADHI on 25/09/23.
//

import SwiftUI

struct CollegeListView: View {
    var colleges: [College] = []
    @State private var isShowFormView = false
    
    init() {
        self.colleges = CoreDataHelper.shared.fetchData(type: College.self, entityName: "College")
    }
    
    var body: some View {
        NavigationView {
            List(self.colleges, id: \.id) { college in
                Text(college.name ?? "")
            }
            .navigationTitle("Colleges")
            .navigationBarItems(trailing: NavigationLink(destination: CollegeFromView(), isActive: $isShowFormView) {
                Button(action: {
                    self.isShowFormView = true
                }, label: {
                    Image(systemName: "plus")
                })
            })
        }
    }
}

struct CollegeListView_Previews: PreviewProvider {
    static var previews: some View {
        CollegeListView()
    }
}
