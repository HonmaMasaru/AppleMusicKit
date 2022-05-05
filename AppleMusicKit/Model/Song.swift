//
//  Song.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

/// 曲のレスポンス
/// https://developer.apple.com/documentation/applemusicapi/songsresponse
struct SongResponse: Codable {
    /// 問い合わせ結果
	let data: [Song]

    // MARK: -
    
    /// IDの取得
    var ids: [String] {
        data.map { $0.id }
    }
}

// MARK: -

/// 曲
/// https://developer.apple.com/documentation/applemusicapi/songs-um8
public struct Song: Codable, Identifiable {
    /// ID
	public let id: String

    /// 関連項目
	public let attributes: Attributes

    /// 関連項目
    /// https://developer.apple.com/documentation/applemusicapi/songs/attributes
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
    /// https://developer.apple.com/documentation/applemusicapi/artwork
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
    /// https://developer.apple.com/documentation/applemusicapi/preview
    public struct Preview: Codable {
        /// URL
        public let url: URL
    }
}

// MARK: -

extension Song: Hashable {
    public static func == (lhs: Song, rhs: Song) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: -

extension Song.Attributes: Hashable {
    public static func == (lhs: Song.Attributes, rhs: Song.Attributes) -> Bool {
        lhs.url == rhs.url
    }
}

// MARK: -

extension Song.Artwork: Hashable {
    public static func == (lhs: Song.Artwork, rhs: Song.Artwork) -> Bool {
        lhs.url == rhs.url
    }
}

// MARK: -

extension Song.Preview: Hashable {
    public static func == (lhs: Song.Preview, rhs: Song.Preview) -> Bool {
        lhs.url == rhs.url
    }
}
