//
//  MenuSliderImageUpdate.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Type returned by ``MenuSliderImage/image(for:oldValue:force:)``.
nonisolated
public enum MenuSliderImageUpdate {
    case noChange
    case newImage(MenuSliderImageDescriptor)
}

extension MenuSliderImageUpdate: Equatable { }

extension MenuSliderImageUpdate: Sendable { }

#endif
