//
//  FirestoreViewModel.swift
//  YourApp
//
//  Created by Douglas Jasper on 2025-02-14.
//

import Foundation
import FirebaseFirestore
import UIKit

struct User: Identifiable {
    var id: String
    var name: String
    var age: Int
    var imagePath: String
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
                    age: data["age"] as? Int ?? 0,
                    imagePath: data["imagePath"] as? String ?? ""
                )
            }
        }
    }

    func addUser(name: String, age: Int, imagePath: String) {
        db.collection("users").addDocument(data: [
            "name": name,
            "age": age,
            "imagePath": imagePath
        ])
    }

    func updateUser(id: String, name: String, age: Int, imagePath: String) {
        db.collection("users").document(id).updateData([
            "name": name,
            "age": age,
            "imagePath": imagePath
        ])
    }

    func deleteUser(id: String) {
        db.collection("users").document(id).delete { error in
            if let error = error {
                print("Error deleting user: \(error)")
            }
        }
    }

    // MARK: - Save Image to Disk
    func saveImageToDisk(image: UIImage) -> String {
        let filename = UUID().uuidString + ".jpg"
        if let data = image.jpegData(compressionQuality: 0.8) {
            let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
            try? data.write(to: fileURL)
        }
        return filename
    }

    // MARK: - Load Image from Disk
    func loadImageFromDisk(fileName: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }

    // MARK: - Get Document Directory
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

