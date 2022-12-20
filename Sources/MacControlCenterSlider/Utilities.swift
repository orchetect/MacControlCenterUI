//
//  Utilities.swift
//  MacControlCenterSlider
//

import SwiftUI

extension CGFloat {
    func clamped(to range: ClosedRange<Self>) -> Self {
        if self < range.lowerBound { return range.lowerBound }
        if self > range.upperBound { return range.upperBound }
        return self
    }
    
    func clamped(to range: PartialRangeFrom<Self>) -> Self {
        if self < range.lowerBound { return range.lowerBound }
        return self
    }
}
