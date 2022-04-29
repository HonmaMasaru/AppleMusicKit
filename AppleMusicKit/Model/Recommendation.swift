//
//  Recommendation.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

struct RecommendationsResponse: Codable {
	let data: [Recommendation]

    var ids: [String] {
        data.reduce(into: [String]()) { $0 += $1.ids }
    }
}

struct Recommendation: Codable {
	let relationships: Relationships

	struct Relationships: Codable {
		let contents: Contents?
		let recommendations: Recommendations?
	}

	struct Contents: Codable {
		let data: [Resource]
	}

	struct Recommendations: Codable {
		let data: [Recommendation]
	}

	struct Resource: Codable {
		let id: String
		let type: String
	}

    fileprivate var ids: [String] {
        var ids = get(playlistID: relationships.contents)
        ids += get(playlistID: relationships.recommendations)
        return ids
    }

    private func get(playlistID contents: Contents?) -> [String] {
        contents?.data.filter { $0.type == "playlists" }.map { $0.id } ?? [String]()
    }

    private func get(playlistID recommendations: Recommendations?) -> [String] {
        recommendations?.data.reduce(into: [String]()) {
            $0 += get(playlistID: $1.relationships.contents)
            $0 += get(playlistID: $1.relationships.recommendations)
        } ?? [String]()
    }
}
