//
//  LibraryPlaylists.swift
//  AppleMusicKit
//
//  Created by Honma Masaru on 2023/04/02.
//

import Foundation

/// ライブラリプレイリストのレスポンス
/// - Note: [LibraryPlaylistsResponse | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/libraryplaylistsresponse)
struct LibraryPlaylistsResponse: Codable {
    /// 問い合わせ結果
    let data: [LibraryPlaylists]
}

// MARK: -

/// ライブラリプレイリスト
/// - Note: [LibraryPlaylists | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/libraryplaylists)
public struct LibraryPlaylists: Codable {
    /// ID
    public let id: String

    /// URL
    public let href: URL

    /// 付加情報
    public let attributes: Attributes

    /// 付加情報
    /// - Note: [LibraryPlaylists.Attributes | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/libraryplaylists/attributes)
    public struct Attributes: Codable {
        /// プレイリスト名
        public let name: String

        /// アートワーク
        public let artwork: Artwork
    }
}
