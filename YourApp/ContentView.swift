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

    var body: some View {
        VStack {
            List(viewModel.users) { user in
                Text("\(user.name) - Age: \(user.age)")
            }
            
            Button("Add User") {
                viewModel.addUser(name: "John Doe", age: Int.random(in: 18...50))
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}


#Preview {
    ContentView()
}
