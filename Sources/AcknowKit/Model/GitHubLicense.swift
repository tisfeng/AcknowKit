//
//  GitHubLicense.swift
//  AcknowKit
//
//  Created by tisfeng on 2024/12/3.
//


// MARK: - GitHubLicense
// https://docs.github.com/zh/rest/licenses/licenses#get-the-license-for-a-repository

public struct GitHubLicense: Codable {
    let name, path, sha: String
    let size: Int
    let url, htmlURL: String
    let gitURL: String
    let downloadURL: String
    let type, content, encoding: String
    let links: Links
    let license: License?

    enum CodingKeys: String, CodingKey {
        case name, path, sha, size, url
        case htmlURL = "html_url"
        case gitURL = "git_url"
        case downloadURL = "download_url"
        case type, content, encoding
        case links = "_links"
        case license
    }

    // MARK: - License
    struct License: Codable {
        let key, name: String
        let spdxID: String?

        let url: String?
        let nodeID: String

        enum CodingKeys: String, CodingKey {
            case key, name
            case spdxID = "spdx_id"
            case url
            case nodeID = "node_id"
        }
    }

    // MARK: - Links
    struct Links: Codable {
        let linksSelf: String
        let git: String
        let html: String

        enum CodingKeys: String, CodingKey {
            case linksSelf = "self"
            case git, html
        }
    }
}

/**
 curl -L 'https://api.github.com/repos/vtourraine/AcknowList/license' \
 --header 'X-GitHub-Api-Version: 2022-11-28' \
 --header 'Accept: application/vnd.github+json' \

 {
     "name": "LICENSE.txt",
     "path": "LICENSE.txt",
     "sha": "27086a35a706efeacb9543ce0556b23a1cd97b7f",
     "size": 1095,
     "url": "https://api.github.com/repos/vtourraine/AcknowList/contents/LICENSE.txt?ref=main",
     "html_url": "https://github.com/vtourraine/AcknowList/blob/main/LICENSE.txt",
     "git_url": "https://api.github.com/repos/vtourraine/AcknowList/git/blobs/27086a35a706efeacb9543ce0556b23a1cd97b7f",
     "download_url": "https://raw.githubusercontent.com/vtourraine/AcknowList/main/LICENSE.txt",
     "type": "file",
     "content": "Q29weXJpZ2h0IChjKSAyMDE1LTIwMjQgVmluY2VudCBUb3VycmFpbmUgKGh0\ndHBzOi8vd3d3LnZ0b3VycmFpbmUubmV0KQoKUGVybWlzc2lvbiBpcyBoZXJl\nYnkgZ3JhbnRlZCwgZnJlZSBvZiBjaGFyZ2UsIHRvIGFueSBwZXJzb24gb2J0\nYWluaW5nIGEgY29weSBvZiB0aGlzIHNvZnR3YXJlIGFuZCBhc3NvY2lhdGVk\nIGRvY3VtZW50YXRpb24gZmlsZXMgKHRoZSAiU29mdHdhcmUiKSwgdG8gZGVh\nbCBpbiB0aGUgU29mdHdhcmUgd2l0aG91dCByZXN0cmljdGlvbiwgaW5jbHVk\naW5nIHdpdGhvdXQgbGltaXRhdGlvbiB0aGUgcmlnaHRzIHRvIHVzZSwgY29w\neSwgbW9kaWZ5LCBtZXJnZSwgcHVibGlzaCwgZGlzdHJpYnV0ZSwgc3VibGlj\nZW5zZSwgYW5kL29yIHNlbGwgY29waWVzIG9mIHRoZSBTb2Z0d2FyZSwgYW5k\nIHRvIHBlcm1pdCBwZXJzb25zIHRvIHdob20gdGhlIFNvZnR3YXJlIGlzIGZ1\ncm5pc2hlZCB0byBkbyBzbywgc3ViamVjdCB0byB0aGUgZm9sbG93aW5nIGNv\nbmRpdGlvbnM6CgpUaGUgYWJvdmUgY29weXJpZ2h0IG5vdGljZSBhbmQgdGhp\ncyBwZXJtaXNzaW9uIG5vdGljZSBzaGFsbCBiZSBpbmNsdWRlZCBpbiBhbGwg\nY29waWVzIG9yIHN1YnN0YW50aWFsIHBvcnRpb25zIG9mIHRoZSBTb2Z0d2Fy\nZS4KClRIRSBTT0ZUV0FSRSBJUyBQUk9WSURFRCAiQVMgSVMiLCBXSVRIT1VU\nIFdBUlJBTlRZIE9GIEFOWSBLSU5ELCBFWFBSRVNTIE9SIElNUExJRUQsIElO\nQ0xVRElORyBCVVQgTk9UIExJTUlURUQgVE8gVEhFIFdBUlJBTlRJRVMgT0Yg\nTUVSQ0hBTlRBQklMSVRZLCBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVS\nUE9TRSBBTkQgTk9OSU5GUklOR0VNRU5ULiBJTiBOTyBFVkVOVCBTSEFMTCBU\nSEUgQVVUSE9SUyBPUiBDT1BZUklHSFQgSE9MREVSUyBCRSBMSUFCTEUgRk9S\nIEFOWSBDTEFJTSwgREFNQUdFUyBPUiBPVEhFUiBMSUFCSUxJVFksIFdIRVRI\nRVIgSU4gQU4gQUNUSU9OIE9GIENPTlRSQUNULCBUT1JUIE9SIE9USEVSV0lT\nRSwgQVJJU0lORyBGUk9NLCBPVVQgT0YgT1IgSU4gQ09OTkVDVElPTiBXSVRI\nIFRIRSBTT0ZUV0FSRSBPUiBUSEUgVVNFIE9SIE9USEVSIERFQUxJTkdTIElO\nIFRIRSBTT0ZUV0FSRS4K\n",
     "encoding": "base64",
     "_links": {
         "self": "https://api.github.com/repos/vtourraine/AcknowList/contents/LICENSE.txt?ref=main",
         "git": "https://api.github.com/repos/vtourraine/AcknowList/git/blobs/27086a35a706efeacb9543ce0556b23a1cd97b7f",
         "html": "https://github.com/vtourraine/AcknowList/blob/main/LICENSE.txt"
     },
     "license": {
         "key": "mit",
         "name": "MIT License",
         "spdx_id": "MIT",
         "url": "https://api.github.com/licenses/mit",
         "node_id": "MDc6TGljZW5zZTEz"
     }
 }
 */
