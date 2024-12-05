//
// GitHubAPI.swift
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

/// An object that interacts with the GitHub API.
open class GitHubAPI {

    /// Gets the repository license.
    /// - Parameter repository: The GitHub URL for the repository. For example: `https://github.com/vtourraine/AcknowList.git`
    ///
    /// GitHub API documentation
    /// https://docs.github.com/en/rest/licenses/licenses#get-the-license-for-a-repository
    ///
    /// - Important: GitHub API primary rate limit for unauthenticated requests is 60 requests per hour. https://docs.github.com/zh/rest/using-the-rest-api/rate-limits-for-the-rest-api?apiVersion=2022-11-28#primary-rate-limit-for-unauthenticated-users
    public static func getLicense(for repository: URL) async throws -> GitHubLicense {
        let request = getLicenseRequest(for: repository)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let license = try JSONDecoder().decode(GitHubLicense.self, from: data)
        return license
    }

    /**
     Returns a Boolean value indicating whether a URL is a valid GitHub repository URL.
     - Parameter repository: The GitHub URL for the repository. For example: `https://github.com/vtourraine/AcknowList.git`
     */
    public static func isGitHubRepository(_ repository: URL) -> Bool {
        return repository.absoluteString.hasPrefix("https://github.com/")
    }

    /// Get author name from the repository URL.
    /// - Parameter repository: The GitHub URL for the repository. For example: `https://github.com/vtourraine/AcknowList.git`
    /// - returns: The author name, vtourraine in the example.
    public static func getAuthorName(from repository: URL) -> String? {
        if isGitHubRepository(repository) {
            let pathComponents = repository.pathComponents
            if pathComponents.count >= 1 {
                return pathComponents[1]
            }
        }
        return nil
    }

    internal static func getLicenseRequest(for repository: URL) -> URLRequest {
        let path = pathWithoutExtension(for: repository)
        let url = "https://api.github.com/repos\(path)/license"
        var request = URLRequest(url: URL(string: url)!)
        request.allHTTPHeaderFields = [
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28",
        ]
        return request
    }

    internal static func pathWithoutExtension(for repository: URL) -> String {
        return repository.path.replacingOccurrences(of: ".git", with: "")
    }
}
