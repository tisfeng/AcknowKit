//
//  AcknowLibrarySection.swift
//
//
//  Created by Kyle on 2023/3/26.
//

import SwiftUI

public struct AcknowLibrarySection: View {
    public let library: AcknowLibrary

    public init(library: AcknowLibrary) {
        self.library = library
    }

    public var body: some View {
        Section {
            ForEach(library.items) { item in
                RowItem(item: item)
            }
        } header: {
            if let header = library.header {
                Text(header)
            }
        } footer: {
            if let footer = library.footer {
                Text(footer)
            }
        }
    }

    /// View that displays a row in a list of acknowledgements.
    public struct RowItem: View {
        @State private var item: AcknowLibrary.Item
        @Environment(\.openURL) private var openURL

        public init(item: AcknowLibrary.Item) {
            _item = State(initialValue: item)
        }

        public var body: some View {
            if item.text != nil
                || (item.repository != nil && GitHubAPI.isGitHubRepository(item.repository!))
            {
                NavigationLink {
                    AcknowLibraryItemView(item: $item)
                } label: {
                    label
                }
            } else if let repository = item.repository,
                canOpenRepository(for: repository)
            {
                Link(destination: repository) {
                    HStack {
                        label.foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "link")
                    }
                }
            } else {
                label
            }
        }

        private var label: some View {
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(item.title)
                    }
                    HStack {
                        if let author = item.author {
                            Text("Author: " + author)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        if let license = item.license {
                            Text("License: " + license.rawValue)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Spacer()

                // Source tag
                Text(item.source.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }

        private func canOpenRepository(for url: URL) -> Bool {
            guard let scheme = url.scheme else {
                return false
            }
            return scheme == "http" || scheme == "https"
        }
    }
}

#Preview {
    NavigationStack {
        AcknowLibrarySection(library: .preview)
    }
}

#Preview {
    NavigationStack {
        Form {
            AcknowLibrarySection.RowItem(item: .init(title: "Demo", text: "License Content", author: "Kyle-Ye", license: .mit))
            AcknowLibrarySection.RowItem(item: .init(title: "Demo", text: "License Content", author: "Kyle-Ye"))
            AcknowLibrarySection.RowItem(item: .init(title: "Demo", text: "License Content", license: .apache))
            AcknowLibrarySection.RowItem(item: .init(title: "Demo", repository: URL(string: "https://github.com/Kyle-Ye/AcknowKit")))
            AcknowLibrarySection.RowItem(item: .init(title: "Demo", repository: URL(string: "git@github.com:Kyle-Ye/AcknowKit.git")))
        }.formStyle(.grouped)
    }
}
