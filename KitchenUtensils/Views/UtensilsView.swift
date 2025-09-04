//
//  UtensilsView.swift
//  KitchenUtensils
//
//  Created by rahul on 9/3/25.
//

import SwiftUI

struct UtensilsView: View {

    @StateObject var vm: UtensilsViewModel
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            Group {
                if vm.items.isEmpty {
                    ContentUnavailableView("No Utensils", systemImage: "fork.knife",
                                           description: Text("Tap + to add your first item."))
                } else {
                    List {
                        ForEach(vm.items) { u in
                            HStack(spacing: 12) {
                                thumbnail(for: u)
                                Text(u.name).font(.body)
                            }
                        }
                        .onDelete(perform: vm.delete)
                    }
                }
            }
            .navigationTitle("Kitchen Utensils")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAdd = true } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddUtensilView(vm: vm)
            }
            .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
                Button("OK") { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }
        }
    }

    @ViewBuilder private func thumbnail(for u: Utensil) -> some View {
        if let img = vm.image(for: u) {
            Image(uiImage: img)
                .resizable().scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            RoundedRectangle(cornerRadius: 8)
                .fill(.secondary.opacity(0.1))
                .frame(width: 56, height: 56)
                .overlay(Image(systemName: "photo"))
        }
    }
}
