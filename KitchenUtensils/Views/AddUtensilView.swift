//
//  AddUtensilView.swift
//  KitchenUtensils
//
//  Created by rahul on 9/3/25.
//

import SwiftUI
import PhotosUI

struct AddUtensilView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: UtensilsViewModel
 

    @State private var name = ""
    @State private var pickerItem: PhotosPickerItem?
    @State private var image: UIImage?

    var canSave: Bool {
        image != nil && !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Photo") {
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Label(image == nil ? "Select Photo" : "Change Photo", systemImage: "photo.on.rectangle")
                    }
                    if let ui = image {
                        Image(uiImage: ui)
                            .resizable().scaledToFit().frame(maxHeight: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                Section("Name") {
                    TextField("e.g. Spatula", text: $name)
                        .textInputAutocapitalization(.words)
                }
            }
            .navigationTitle("New Utensil")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }.disabled(!canSave)
                }
            }
            .onChange(of: pickerItem) { _, newValue in
                Task { await loadImage(from: newValue) }
            }
        }
    }

    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item else { image = nil; return }
        if let data = try? await item.loadTransferable(type: Data.self),
           let ui = UIImage(data: data) {
            image = ui
        }
    }

    private func save() {
        guard let image else { return }
        vm.add(name: name, image: image)
        dismiss()
    }
}

