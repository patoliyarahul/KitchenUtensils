//
//  Persistence.swift
//  KitchenUtensils
//
//  Created by rahul on 9/3/25.
//

import UIKit

enum Persistence {
    private static var docs: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    private static var dataURL: URL { docs.appendingPathComponent("utensils.json") }

    static func saveImage(_ image: UIImage) throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.9) else { throw NSError() }
        let filename = UUID().uuidString + ".jpg"
        try data.write(to: docs.appendingPathComponent(filename), options: .atomic)
        return filename
    }

    static func loadImage(named: String) -> UIImage? {
        let url = docs.appendingPathComponent(named)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    static func deleteImage(named: String) {
        try? FileManager.default.removeItem(at: docs.appendingPathComponent(named))
    }

    static func loadItems() -> [Utensil] {
        guard let data = try? Data(contentsOf: dataURL) else { return [] }
        return (try? JSONDecoder().decode([Utensil].self, from: data)) ?? []
    }

    static func saveItems(_ items: [Utensil]) throws {
        let data = try JSONEncoder().encode(items)
        try data.write(to: dataURL, options: .atomic)
    }
}
