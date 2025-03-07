//
//  ContentView.swift
//  YourApp
//
//  Created by Douglas Jasper on 2025-02-14.
//

import SwiftUI
import FirebaseFirestore
import PhotosUI

struct ContentView: View {
    @StateObject private var viewModel = FirestoreViewModel()
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var selectedImage: UIImage?
    @State private var imagePickerPresented = false
    @State private var editingUser: User?

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.users) { user in
                    HStack {
                        if let image = viewModel.loadImageFromDisk(fileName: user.imagePath) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }

                        if editingUser?.id == user.id {
                            TextField("Name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            TextField("Age", text: $age)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Button("Save") {
                                if let ageInt = Int(age), let userId = editingUser?.id {
                                    viewModel.updateUser(id: userId, name: name, age: ageInt, imagePath: user.imagePath)
                                    editingUser = nil
                                }
                            }
                            .padding(.horizontal)
                        } else {
                            VStack(alignment: .leading) {
                                Text("\(user.name) - Age: \(user.age)")
                            }
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
            
            Button("Select Image") {
                imagePickerPresented.toggle()
            }
            .sheet(isPresented: $imagePickerPresented) {
                ImagePicker(image: $selectedImage)
            }

            TextField("Enter Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Enter Age", text: $age)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add User") {
                if let ageInt = Int(age), let image = selectedImage {
                    let savedFileName = viewModel.saveImageToDisk(image: image)
                    viewModel.addUser(name: name, age: ageInt, imagePath: savedFileName)
                    name = ""
                    age = ""
                    selectedImage = nil
                }
            }
            .padding()
            .disabled(name.isEmpty || age.isEmpty || selectedImage == nil)

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
