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

    var body: some View {
        VStack {
            List(viewModel.users) { user in
                Text("\(user.name) - Age: \(user.age)")
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
