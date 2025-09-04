//
//  Utensil.swift
//  KitchenUtensils
//
//  Created by rahul on 9/3/25.
//

import Foundation

struct Utensil: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
 
    var photoFilename: String
    var createdAt: Date

    init(id: UUID = UUID(), name: String, photoFilename: String, createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.photoFilename = photoFilename
        self.createdAt = createdAt
    }
    
    private static func == (lhs: Utensil, rhs: Utensil) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
