//
//  File.swift
//  AcknowKit
//
//  Created by tisfeng on 2024/12/3.
//

import Foundation

extension String {
    var base64: String {
        return Data(self.utf8).base64EncodedString()
    }

    var unbase64: String {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return ""
        }
        return data.stringVlue ?? ""
    }
}

extension Data {
    var stringVlue: String? {
        return String(data: self, encoding: .utf8)
    }
}
