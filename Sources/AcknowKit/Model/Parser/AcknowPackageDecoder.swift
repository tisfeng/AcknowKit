//
// AcknowPackageDecoder.swift
//
// Copyright (c) 2015-2024 Vincent Tourraine (https://www.vtourraine.net)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// An object that decodes acknowledgements from Swift Package Manager “resolved” file objects.
open class AcknowPackageDecoder: AcknowDecoder {

    public init() {}

    /**
     Returns acknowledgements decoded from a Swift Package Manager “resolved” file object.
     - Parameter data: The Swift Package Manager “resolved” file object to decode.
     - Returns: A `AcknowList` value, if the decoder can parse the data.
     */
    public func decode(from data: Data) throws -> AcknowLibrary {
        let decoder = JSONDecoder()
        var acknows: [AcknowLibrary.Item] = []

        if let root = try? decoder.decode(JSONV1Root.self, from: data) {
             acknows = root.object.pins.map {
                let repositoryURL = URL(string: $0.repositoryURL)!
                 return .init(
                    title: $0.package,
                    author: GitHubAPI.getAuthorName(from: repositoryURL),
                    repository: repositoryURL,
                    source: .package)
            }
            return .init(items: acknows, header: nil, footer: nil)
        }

        let root = try decoder.decode(JSONV2Root.self, from: data)
        acknows = root.pins.map {
            let repositoryURL = URL(string: $0.location)!
            return .init(
                title: $0.identity,
                author: GitHubAPI.getAuthorName(from: repositoryURL),
                repository: repositoryURL,
                source: .package)
        }
        return .init(items: acknows, header: nil, footer: nil)
    }

    // MARK: - JSON format

    struct JSONV1Root: Codable {
        let object: JSONV1Object
        let version: Int
    }

    struct JSONV1Object: Codable {
        let pins: [JSONV1Pin]
    }

    struct JSONV1Pin: Codable {
        let package: String
        let repositoryURL: String
    }

    struct JSONV2Root: Codable {
        let pins: [JSONV2Pin]
        let version: Int
    }

    struct JSONV2Pin: Codable {
        let identity: String
        let location: String
    }
}
