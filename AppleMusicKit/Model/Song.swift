//
//  Song.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

struct SongResponse: Codable {
	let data: [Song]

    var ids: [String] {
        data.map { $0.id }
    }
}

public struct Song: Codable, Identifiable {
	public let id: String
	public let attributes: Attributes

	public struct Attributes: Codable {
        public let name: String
        public let albumName: String
        public let artistName: String
		public let url: URL
		public let artwork: Artwork
        public let previews: [Preview]
	}

    public struct Artwork: Codable {
        public let url: String
        public let bgColor: String
        public let width: Int
        public let height: Int
    }

    public struct Preview: Codable {
        public let url: URL
    }
}

extension Song: Hashable {
    public static func == (lhs: Song, rhs: Song) -> Bool {
        lhs.id == rhs.id
    }
}

extension Song.Attributes: Hashable {
    public static func == (lhs: Song.Attributes, rhs: Song.Attributes) -> Bool {
        lhs.url == rhs.url
    }
}

extension Song.Artwork: Hashable {
    public static func == (lhs: Song.Artwork, rhs: Song.Artwork) -> Bool {
        lhs.url == rhs.url
    }
}

extension Song.Preview: Hashable {
    public static func == (lhs: Song.Preview, rhs: Song.Preview) -> Bool {
        lhs.url == rhs.url
    }
}
