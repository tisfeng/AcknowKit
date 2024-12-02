//
//  AcknowLibraryForm.swift
//
//
//  Created by Kyle on 2023/11/24.
//

import SwiftUI

public struct AcknowLibraryForm: View {
    public let library: AcknowLibrary

    public init(library: AcknowLibrary? = nil) {
        self.library = library ?? AcknowParser.defaultAcknowList() ?? .init(items: [])
    }

    public var body: some View {
        Form {
            AcknowLibrarySection(library: library)
        }
        .formStyle(.grouped)
        .navigationTitle("Acknowledgements")
    }
}

#Preview {
    NavigationStack {
        AcknowLibraryForm(library: .preview)
    }
}
