//
//  AcknowLibraryView.swift
//  AcknowKit
//
//  Created by tisfeng on 2024/12/2.
//

import SwiftUI

public struct AcknowLibraryView: View {
    public let library: AcknowLibrary
    public let style: Style

    public enum Style {
        case form
        case list
    }

    /// Initializes a new `AcknowLibraryView`.
    /// - Parameters:
    ///   - library: The acknowledgements library to display. If nil, the default acknowledgements library will be used.
    ///   - manualItems: An array of acknowledgements to be added manually to the acknowledgements library.
    ///   - style: The style of the view, defaults to `.form`.
    public init(
        library: AcknowLibrary? = AcknowParser.defaultAcknowLibrary(),
        manualItems: [AcknowLibrary.Item] = [],
        isSourceVisible: Bool = true,
        style: Style = .form
    ) {
        self.style = style

        var acknowLibrary = library
        let defaultItems = acknowLibrary?.items ?? []

        acknowLibrary?.items = manualItems + defaultItems
        acknowLibrary?.items.setSourceVisibility(isSourceVisible)

        self.library = acknowLibrary ?? .init(items: manualItems)
    }

    public var body: some View {
        switch style {
        case .form:
            AcknowLibraryForm(library: library)
        case .list:
            AcknowLibraryList(library: library)
        }
    }
}

#Preview {
    NavigationStack {
        AcknowLibraryView(library: .preview)
    }
}
