//
//  Playlist.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

/// プレイリストのレスポンス
/// - Note: [ChartResponse.Results.SongsChart | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/chartresponse/results/songschart)
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
/// - Note: [Playlists | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/playlists-ulf)
struct Playlist: Codable {
    /// プレイリストID
    var id: String

    /// 関連項目
    var relationships: Relationships

    /// 関連項目
    /// - Note: [Playlists.Relationships | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/playlists/relationships)
    struct Relationships: Codable {
        /// トラック
        var tracks: TrackRelationship
    }

    /// トラック
    /// - Note: [Playlists.Relationships.PlaylistsTracksRelationship | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/playlists/relationships/playliststracksrelationship)
    struct TrackRelationship: Codable {
        /// リソース
        /// - Note: 本来は[(Song | MusicVideo)]
        var data: [Resource]
    }

    /// リソース
    /// - Note: [Playlists.Relationships.PlaylistsTracksRelationship | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/playlists/relationships/playliststracksrelationship)
    struct Resource: Codable {
        var id: String
    }
}
