//
//  MenuEntry.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Menu entry metadata.
struct MenuEntry: Hashable, Identifiable {
    let name: String
    let image: Image
    let imageColor: Color?
    
    // Identifiable
    var id: String { name }
    
    // Hashable - custom since Image isn't Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(name: String, image: Image, imageColor: Color? = nil) {
        self.name = name
        self.image = image
        self.imageColor = imageColor
    }
    
    init(name: String, systemImage: String, imageColor: Color? = nil) {
        self.name = name
        image = Image(systemName: systemImage)
        self.imageColor = imageColor
    }
}
