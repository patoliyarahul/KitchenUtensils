//
//  KitchenUtensilsApp.swift
//  KitchenUtensils
//
//  Created by rahul on 9/3/25.
//

import SwiftUI

@main
struct KitchenUtensilsApp: App {
    private let repo = DiskUtensilsRepository()
    
    var body: some Scene {
        WindowGroup {
                  UtensilsView(vm: UtensilsViewModel(repo: repo))
              }
    }
}
