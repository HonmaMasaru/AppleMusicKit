//
//  Playlist.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

/// プレイリストのレスポンス
/// https://developer.apple.com/documentation/applemusicapi/playlistsresponse
struct PlaylistResponse: Codable {
    /// 問い合わせ結果
    var data: [Playlist]

    // MARK: -

    /// IDの取得
    var ids: [String] {
        data.reduce(into: [String]()) {
            $0 += [$1.id]
            $0 += $1.relationships.tracks.data.map { $0.id }
        }
    }
}

// MARK: -

/// プレイリスト
/// https://developer.apple.com/documentation/applemusicapi/playlists-ulf
struct Playlist: Codable {
    /// プレイリストID
    var id: String

    /// 関連項目
    var relationships: Relationships

    /// 関連項目
    /// https://developer.apple.com/documentation/applemusicapi/playlists/relationships
    struct Relationships: Codable {
        /// トラック
        var tracks: TrackRelationship
    }

    /// トラック
    /// https://developer.apple.com/documentation/applemusicapi/playlists/relationships/playliststracksrelationship
    struct TrackRelationship: Codable {
        /// リソース
        /// - Note: 本来は[(Song | MusicVideo)]
        var data: [Resource]
    }

    /// リソース
    /// https://developer.apple.com/documentation/applemusicapi/playlists/relationships/playliststracksrelationship
    struct Resource: Codable {
        var id: String
    }
}
