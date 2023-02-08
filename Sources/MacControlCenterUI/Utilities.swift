//
//  Utilities.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension CGFloat {
    internal func clamped(to range: ClosedRange<Self>) -> Self {
        if self < range.lowerBound { return range.lowerBound }
        if self > range.upperBound { return range.upperBound }
        return self
    }
    
    internal func clamped(to range: PartialRangeFrom<Self>) -> Self {
        if self < range.lowerBound { return range.lowerBound }
        return self
    }
}
