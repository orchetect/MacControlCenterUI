//
//  API-2.4.0.swift
//  MacControlCenterUI • https://github.com/orchetect/MacControlCenterUI
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

extension MenuDisclosureSection {
    // MARK: Init - With Binding
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(divider:isExpanded:_:label:)")
    public init<LabelContent: View>(
        divider: Bool = true,
        isExpanded: Binding<Bool>,
        @ViewBuilder _ label: () -> LabelContent,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) where Label == MenuSectionText<LabelContent> {
        self.init(
            divider: divider,
            isExpanded: isExpanded,
            content,
            label: label
        )
    }
    
    // MARK: Init - Without Binding
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(divider:initiallyExpanded:_:label:)")
    public init<LabelContent: View>(
        divider: Bool = true,
        initiallyExpanded: Bool = true,
        @ViewBuilder _ label: () -> LabelContent,
        @MacControlCenterMenuBuilder _ content: @escaping () -> [any View]
    ) where Label == MenuSectionText<LabelContent> {
        self.init(
            divider: divider,
            initiallyExpanded: initiallyExpanded,
            content,
            label: label
        )
    }
}

#endif
