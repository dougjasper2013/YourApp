//
//  FirestoreViewModel.swift
//  YourApp
//
//  Created by Douglas Jasper on 2025-02-14.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable {
    var id: String
    var name: String
    var age: Int
}

class FirestoreViewModel: ObservableObject {
    @Published var users: [User] = []
    
    private var db = Firestore.firestore()

    func fetchUsers() {
        db.collection("users").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            self.users = documents.map { doc in
                let data = doc.data()
                return User(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "Unknown",
                    age: data["age"] as? Int ?? 0
                )
            }
        }
    }

    func addUser(name: String, age: Int) {
        db.collection("users").addDocument(data: [
            "name": name,
            "age": age
        ])
    }

    func updateUser(id: String, name: String, age: Int) {
        db.collection("users").document(id).updateData([
            "name": name,
            "age": age
        ])
    }

    func deleteUser(id: String) {
        db.collection("users").document(id).delete { error in
            if let error = error {
                print("Error deleting user: \(error)")
            }
        }
    }
}

