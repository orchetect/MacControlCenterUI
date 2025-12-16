//
//  MenuWidth.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

nonisolated
public enum MenuWidth {
    /// Standard menu width on macOS 26 (Tahoe).
    case macOS26
    
    /// Standard menu width on macOS 11 (Big Sur) through 15 (Sequoia).
    case macOS11Thru15
    
    /// Custom menu width.
    case custom(CGFloat)
}

extension MenuWidth: Equatable { }

extension MenuWidth: Hashable { }

extension MenuWidth: Sendable { }

// MARK: - Static Constructors

extension MenuWidth {
    /// Returns the menu width appropriate for the current version of macOS.
    public static func currentPlatform() -> Self {
        if #available(macOS 26.0, *) {
            return .macOS26
        } else if #available(macOS 11.0, *) {
            return .macOS11Thru15
        } else {
            // fallback
            return .macOS11Thru15
        }
    }
}

// MARK: - Properties

extension MenuWidth {
    public var width: CGFloat {
        switch self {
        case .macOS26: return 310.0
        case .macOS11Thru15: return 300.0
        case let .custom(width): return width
        }
    }
}

#endif
