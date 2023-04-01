//
//  Songs.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

/// 曲のレスポンス
/// - Note: [SongsResponse | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/songsresponse)
struct SongResponse: Codable {
    /// 問い合わせ結果
    let data: [Songs]

    // MARK: -

    /// IDの取得
    var ids: [String] {
        data.map { $0.id }
    }
}

// MARK: -

/// 曲
/// - Note: [Songs | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/songs-um8)
public struct Songs: Codable, Identifiable {
    /// ID
    public let id: String

    /// 関連項目
    public let attributes: Attributes

    /// 関連項目
    /// - Note: [Songs.Attributes | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/songs/attributes)
    public struct Attributes: Codable {
        /// 曲名
        public let name: String

        /// アルバム名
        public let albumName: String

        /// アーティスト名
        public let artistName: String

        /// URL
        public let url: URL

        /// アートワーク
        public let artwork: Artwork

        /// プレビュー
        public let previews: [Preview]
    }

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

    /// プレビュー
    /// - Note: [Preview | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/preview)
    public struct Preview: Codable {
        /// URL
        public let url: URL
    }
}

// MARK: -

extension Songs: Hashable {
    public static func == (lhs: Songs, rhs: Songs) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: -

extension Songs.Attributes: Hashable {
    public static func == (lhs: Songs.Attributes, rhs: Songs.Attributes) -> Bool {
        lhs.url == rhs.url
    }
}

// MARK: -

extension Songs.Artwork: Hashable {
    public static func == (lhs: Songs.Artwork, rhs: Songs.Artwork) -> Bool {
        lhs.url == rhs.url
    }
}

// MARK: -

extension Songs.Preview: Hashable {
    public static func == (lhs: Songs.Preview, rhs: Songs.Preview) -> Bool {
        lhs.url == rhs.url
    }
}
