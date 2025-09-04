//
//  UtensilsViewModel.swift
//  KitchenUtensils
//
//  Created by rahul on 9/3/25.
//

import SwiftUI

@MainActor
final class UtensilsViewModel: ObservableObject {
    @Published private(set) var items: [Utensil] = []
    @Published var errorMessage: String?
    
    private let repo: UtensilsRepository
    
    init(repo: UtensilsRepository) {
        self.repo = repo
        self.items = repo.load()
    }

    func add(name: String, image: UIImage) {
        do {
            let new = try repo.add(name: name, image: image)
            items.append(new)
            try repo.saveAll(items)
        } catch {
            errorMessage = "Failed to save. Please try again."
        }
    }

    func delete(at offsets: IndexSet) {
        let toDelete = offsets.map { items[$0] }
        items.remove(atOffsets: offsets)
        repo.delete(toDelete)
        try? repo.saveAll(items)
    }

    func rename(_ item: Utensil, to newName: String) {
        guard let idx = items.firstIndex(of: item) else { return }
        items[idx].name = newName
        try? repo.saveAll(items)
    }

    func image(for item: Utensil) -> UIImage? {
        repo.image(for: item)
    }
}
