//
//  AcknowLibraryItem.swift
//
//
//  Created by Kyle on 2023/3/26.
//

import SwiftUI

extension AcknowLibrary {
    public struct Item {
        public init(title: String, text: String? = nil, author: String? = nil, license: License? = nil, repository: URL? = nil) {
            self.title = title
            self.text = text
            self.author = author
            self.license = license
            self.repository = repository
        }

        /// The name of the library
        public let title: String

        /// The license content of the library
        public var text: String?

        /// The name of the library's author
        public var author: String?

        /// The license type of the library
        public var license: License?

        /// The repository URL of the library's source code
        public let repository: URL?
    }
}

extension AcknowLibrary.Item: Hashable {}

extension AcknowLibrary.Item: Identifiable {
    public var id: Int { hashValue }
}
