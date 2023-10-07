//
//  StudentFormView.swift
//  CoreData-SwiftUI
//
//  Created by Priyanshi Bhikadiya on 01/10/23.
//

import SwiftUI

struct StudentFormView: View {
    @State private var profileImage: UIImage = UIImage()
    @State private var imagePicker = false
    @State private var studentName = ""
    @State private var age: Double = 0
    @State var selectedCollege = College()
    var colleges: [College]
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Image(uiImage: self.profileImage)
                            .resizable()
                            .scaledToFit()
                            .edgesIgnoringSafeArea(.all)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.gray,lineWidth: 5))
                            .frame(width: 200, height: 200)
                        
                        Button {
                            imagePicker.toggle()
                        } label: {
                            Text("Add Image")
                        }
                        .sheet(isPresented: $imagePicker) {
                            ImagePickerView(selectedImage: $profileImage)
                        }
                        
                    }
                    Spacer()
                }
                
                TextField("Add Student Name", text: $studentName)
                HStack {
                    Text("Age: \(Int(self.age))")
                        .padding(.trailing)
                    Slider(value: $age, in: 0...100)
                }
                CollegePickerView(colleges: colleges, selectedCollege: $selectedCollege)
                
            }
        }
        
    }

}

struct CollegeFormView_Previews: PreviewProvider {
    static var previews: some View {
        StudentFormView(colleges: [])
    }
}

struct CollegePickerView: View {
    var colleges: [College] = []
    @Binding var selectedCollege: College
    
    var body: some View {
        Picker("Select College", selection: $selectedCollege) {
            ForEach(colleges, id: \.self) {
                Text($0.name ?? "")
//                    .tag($0.id)
            }
        }
    }
}
