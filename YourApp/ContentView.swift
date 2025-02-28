//
//  ContentView.swift
//  YourApp
//
//  Created by Douglas Jasper on 2025-02-14.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @StateObject private var viewModel = FirestoreViewModel()
    @State private var name: String = ""
    @State private var age: String = ""
    
    @State private var editingUser: User?  // Stores the user being edited

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.users) { user in
                    HStack {
                        if editingUser?.id == user.id {
                            TextField("Name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Age", text: $age)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Button("Save") {
                                if let ageInt = Int(age), let userId = editingUser?.id {
                                    viewModel.updateUser(id: userId, name: name, age: ageInt)
                                    editingUser = nil
                                }
                            }
                            .padding(.horizontal)
                        } else {
                            Text("\(user.name) - Age: \(user.age)")
                            Spacer()
                            Button("Edit") {
                                editingUser = user
                                name = user.name
                                age = "\(user.age)"
                            }
                            .padding(.trailing)

                            Button("🗑") {
                                viewModel.deleteUser(id: user.id)
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
            }
            
            TextField("Enter Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Enter Age", text: $age)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add User") {
                if let ageInt = Int(age) {
                    viewModel.addUser(name: name, age: ageInt)
                    name = ""
                    age = ""
                }
            }
            .padding()
            .disabled(name.isEmpty || age.isEmpty)

        }
        .onAppear {
            viewModel.fetchUsers()
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
