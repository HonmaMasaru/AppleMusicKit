//
//  Playlist.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

struct PlaylistResponse: Codable {
	var data: [Playlist]

    var ids: [String] {
        data.reduce(into: [String]()) {
            $0 += [$1.id]
            $0 += $1.relationships.tracks.data.map { $0.id }
        }
    }
}

struct Playlist: Codable {
    var id: String
    var relationships: Relationships

    struct Relationships: Codable {
        var tracks: TrackRelationship
    }

    struct TrackRelationship: Codable {
        var data: [Resource] // 本来は[(Song | MusicVideo)]
    }

    struct Resource: Codable {
        var id: String
    }
}
