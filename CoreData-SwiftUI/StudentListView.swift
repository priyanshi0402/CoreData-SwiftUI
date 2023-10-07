//
//  StudentListView.swift
//  CoreData-SwiftUI
//
//  Created by Priyanshi Bhikadiya on 01/10/23.
//

import SwiftUI

struct StudentListView: View {
    
    var students: [Student] = []
    var colleges: [College] = []
    @Binding var selectedCollege: College
    
    var body: some View {
        List(self.students) { student in
            Text(student.name ?? "")
        }
        .navigationBarItems(trailing: NavigationLink(destination: {
            StudentFormView(colleges: self.colleges)
        }, label: {
            Text("Add Student")
        }))
    }
}

struct StudentListView_Previews: PreviewProvider {
    static var previews: some View {
        StudentListView(selectedCollege: .constant(College()))
    }
}
