//
//  ContentView.swift
//  Example
//
//  Created by tisfeng on 2024/12/2.
//

import AcknowKit
import SwiftUI

struct ContentView: View {

    init() {
        manualItems.showSource(true)
    }

    var body: some View {
        NavigationStack {
            AcknowLibraryView(manualItems: manualItems)
        }
    }

    /// Manual acknow items
    private var manualItems: [AcknowLibrary.Item] =
        [
            .init(
                title: "DictionaryKit",
                author: "NSHipster",
                repository: URL(string: "https://github.com/NSHipster/DictionaryKit.git")
            ),
            .init(
                title: "Snip",
                repository: URL(string: "https://github.com/isee15/Capture-Screen-For-Multi-Screens-On-Mac")
            ),
        ]
}

#Preview {
    ContentView()
}
