//
//  UtensilsRepository.swift
//  KitchenUtensils
//
//  Created by rahul on 9/3/25.
//

import UIKit

protocol UtensilsRepository {
    func load() -> [Utensil]
    func add(name: String, image: UIImage) throws -> Utensil
    func delete(_ items: [Utensil])
    func saveAll(_ items: [Utensil]) throws
    func image(for item: Utensil) -> UIImage?
}
