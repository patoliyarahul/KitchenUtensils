//
//  DiskUtensilsRepository.swift
//  KitchenUtensils
//
//  Created by rahul on 9/3/25.
//

import UIKit

final class DiskUtensilsRepository: UtensilsRepository {
    private let docs: URL
    private let dataURL: URL

    init(fileManager: FileManager = .default) {
        self.docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.dataURL = docs.appendingPathComponent("utensils.json")
    }

    func load() -> [Utensil] {
        guard let data = try? Data(contentsOf: dataURL) else { return [] }
        return (try? JSONDecoder().decode([Utensil].self, from: data)) ?? []
    }

    func add(name: String, image: UIImage) throws -> Utensil {
        let filename = try saveImage(image)
        return Utensil(name: name, photoFilename: filename)
    }

    func delete(_ items: [Utensil]) {
        for u in items {
            try? FileManager.default.removeItem(at: docs.appendingPathComponent(u.photoFilename))
        }
    }

    func saveAll(_ items: [Utensil]) throws {
        let data = try JSONEncoder().encode(items)
        try data.write(to: dataURL, options: .atomic)
    }

    func image(for item: Utensil) -> UIImage? {
        let url = docs.appendingPathComponent(item.photoFilename)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    private func saveImage(_ image: UIImage) throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.9) else {
            throw NSError(domain: "ImageEncoding", code: -1)
        }
        let filename = UUID().uuidString + ".jpg"
        try data.write(to: docs.appendingPathComponent(filename), options: .atomic)
        return filename
    }
}
