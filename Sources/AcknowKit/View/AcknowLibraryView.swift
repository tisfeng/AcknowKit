//
//  File.swift
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

    public init(library: AcknowLibrary? = nil, style: Style = .form) {
        self.style = style
        self.library = library ?? AcknowParser.defaultAcknowList() ?? .init(items: [])
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
