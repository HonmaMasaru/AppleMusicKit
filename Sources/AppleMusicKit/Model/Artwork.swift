//
//  Artwork.swift
//  AppleMusicKit
//
//  Created by Honma Masaru on 2023/04/02.
//

import Foundation

/// アートワーク
/// - Note: [Artwork | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/artwork)
public struct Artwork: Codable {
    /// URL
    public let url: String

    /// 背景色
    public let bgColor: String

    /// 幅
    public let width: Int

    /// 高さ
    public let height: Int
}

// MARK: -

extension Artwork: Hashable {
    public static func == (lhs: Artwork, rhs: Artwork) -> Bool {
        lhs.url == rhs.url
    }
}
