//
//  Playlists.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

/// プレイリストのレスポンス
/// - Note: [PlaylistsResponse | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/playlistsresponse)
struct PlaylistResponse: Codable {
    /// 問い合わせ結果
    let data: [Playlists]
}

// MARK: -

/// プレイリスト
/// - Note: [Playlists | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/playlists-ulf)
public struct Playlists: Codable {
    /// プレイリストID
    public let id: String

    /// 関連項目
    public let relationships: Relationships

    /// 関連項目
    /// - Note: [Playlists.Relationships | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/playlists/relationships)
    public struct Relationships: Codable {
        /// トラック
        public let tracks: TrackRelationship
    }

    /// トラック
    /// - Note: [Playlists.Relationships.PlaylistsTracksRelationship | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/playlists/relationships/playliststracksrelationship)
    public struct TrackRelationship: Codable {
        /// リソース
        /// - Note: 本来は[(Song | MusicVideo)]
        public let data: [Resource]
    }

    /// リソース
    /// - Note: [Playlists.Relationships.PlaylistsTracksRelationship | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/playlists/relationships/playliststracksrelationship)
    public struct Resource: Codable {
        public let id: String
    }
}
