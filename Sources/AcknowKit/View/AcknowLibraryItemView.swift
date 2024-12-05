//
//  AcknowLibraryItemView.swift
//
//
//  Created by Kyle on 2023/3/26.
//

import SwiftUI

/// View that displays a single acknowledgement.
public struct AcknowLibraryItemView: View {
    /// The acknowledgement item
    @Binding private var item: AcknowLibrary.Item

    @State private var isLoading = false

    public init(item: Binding<AcknowLibrary.Item>) {
        self._item = item
    }

    @Environment(\.openURL) private var openURL

    public var body: some View {
        ZStack {
            ScrollView {
                VStack {
#if os(macOS)
                    Text(item.title)
                        .font(.title)
                        .padding()
#endif
                    if let text = item.text {
                        Text(text)
                            .font(.body)
                            .padding()
                            .textSelection(.enabled)
#if os(macOS)
                            .copyable([text])
#endif
                    }
                }
            }

            if isLoading {
                ProgressView()
                    .scaleEffect(1.3)
            }
        }
        .toolbar {
            if let repository = item.repository,
               canOpenRepository(for: repository) {
                ToolbarItem(id: "open-link", placement: .primaryAction) {
                    Button {
                        openURL(repository)
                    } label: {
                        Label("Open RepoLink", systemImage: "link")
                    }
                }
            }
        }
        .navigationTitle(item.title)
        .onAppear {
            fetchLicenseIfNecessary()
        }
    }

    private func canOpenRepository(for url: URL) -> Bool {
        guard let scheme = url.scheme else {
            return false
        }
        return scheme == "http" || scheme == "https"
    }

    private func fetchLicenseIfNecessary() {
        guard item.text == nil,
            let repository = item.repository,
            GitHubAPI.isGitHubRepository(repository)
        else {
            return
        }

        Task {
            do {
                isLoading = true

                let gitHubLicense = try await GitHubAPI.getLicense(for: repository)
                item.text = gitHubLicense.content.unbase64

                if let license = gitHubLicense.license, let url = license.url {
                    let licenseName = license.spdxID ?? license.name
                    item.license = .init(rawValue: licenseName, link: URL(string: url))
                }

                isLoading = false
            } catch {
                isLoading = false
                print("Failed to fetch license: ", error)
            }
        }
    }
}

#Preview("Complete") {
    NavigationStack {
        AcknowLibraryItemView(item: .constant(.itemComplete))
    }
}

#Preview("Empty") {
    NavigationStack {
        AcknowLibraryItemView(item: .constant(.itemEmpty))
    }
}

#Preview("Demo") {
    NavigationStack {
        AcknowLibraryItemView(item: .constant(.init(title: "Demo", text: "Demo Content")))
    }
}
