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
            List {
                ForEach(colleges, id: \.id) { college in
                    HStack {
                        Text(college.name ?? "")
                        Spacer()
//                        NavigationLink(destination: CollegeFromView(isForView: true, college: college)) {
//                            VStack {
//                                Image(systemName: "info.circle")
//                            }
//                            
//                        }
                        Button(action: {
                            // Handle edit button action here
                            // You can navigate to CollegeFormView with edit mode enabled, for example
//                             NavigationLink(destination: CollegeFromView()) {
//                                 Image(systemName: "pencil.circle")
//                             }
                        }) {
                            Image(systemName: "info.circle")
//                            Image(systemName: "pencil.circle")
                        }
                    }
                    
                }
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

struct SwipeListActions<Content: View>: View {
    
    var content: () -> Content
    var editAction: () -> Void
    var deleteAction: () -> Void
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            content()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation {
                                self.offset = max(min(value.translation.width, 0), -200)
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                if self.offset < -100 {
                                    self.deleteAction()
                                } else if self.offset < -50 {
                                    self.editAction()
                                }
                                self.offset = 0
                            }
                        }
                )
            
            Button(action: {
                withAnimation {
                    self.deleteAction()
                    self.offset = 0
                }
            }) {
                Text("Delete")
                    .foregroundColor(.white)
                    .frame(width: 100)
                    .background(Color.red)
            }
            .contentShape(Rectangle())
        }
        .frame(height: 50)
    }
    
}

struct CollegeListView_Previews: PreviewProvider {
    static var previews: some View {
        CollegeListView()
    }
}
