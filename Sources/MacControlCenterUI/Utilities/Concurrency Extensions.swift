//
//  Concurrency Extensions.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

fileprivate let maxSeconds = TimeInterval(UInt64.max) / TimeInterval(NSEC_PER_SEC)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task where Success == Never, Failure == Never {
    /// Suspends the current task for at least the given duration in seconds.
    /// (Backwards-compatible implementation of `Task.sleep(for: .seconds())`)
    public static func sleep(seconds: TimeInterval) async throws {
        // safety check: protect again overflow
        
        let secondsClamped = min(seconds, maxSeconds)
        let nanoseconds = UInt64(secondsClamped * Double(NSEC_PER_SEC))
        
        try await sleep(nanoseconds: nanoseconds)
    }
}
