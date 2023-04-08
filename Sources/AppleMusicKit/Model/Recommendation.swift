//
//  Recommendation.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

/// レコメンドのレスポンス
/// - Note: [PersonalRecommendationResponse | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/personalrecommendationresponse)
struct RecommendationsResponse: Codable {
    /// 問い合わせ結果
    let data: [Recommendation]
}

// MARK: -

/// レコメンド
/// - Note: [PersonalRecommendation | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/personalrecommendation)
public struct Recommendation: Codable {
    /// 関連項目
    public let relationships: Relationships

    /// 関連項目
    /// - Note: [PersonalRecommendation.Relationships | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/personalrecommendation/relationships)
    public struct Relationships: Codable {
        /// コンテンツ
        public let contents: Contents?

        /// レコメンド
        public let recommendations: Recommendations?
    }

    /// コンテンツ
    /// - Note: [PersonalRecommendation.Relationships.PersonalRecommendationContentsRelationship | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/personalrecommendation/relationships/personalrecommendationcontentsrelationship)
    public struct Contents: Codable {
        /// リソース
        public let data: [Resource]
    }

    /// リソース
    /// - Note: [Resource | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/resource)
    public struct Resource: Codable {
        /// ID
        public let id: String

        /// タイプ
        public let type: String
    }

    /// レコメンド
    public struct Recommendations: Codable {
        /// レコメンド内容
        public let data: [Recommendation]
    }
}

// MARK: -

extension Recommendation {
    /// IDの取得
    fileprivate var ids: [String] {
        var ids = get(playlistID: relationships.contents)
        ids += get(playlistID: relationships.recommendations)
        return ids
    }

    /// プレイリストからプレイリストIDを取得
    /// - Parameter contents: コンテンツ
    /// - Returns: プレイリストID (複数)
    private func get(playlistID contents: Contents?) -> [String] {
        contents?.data.filter { $0.type == "playlists" }.map { $0.id } ?? [String]()
    }

    /// プレイリストから曲IDを取得
    /// - Parameter recommendations: レコメンド
    /// - Returns: プレイリストID (複数)
    private func get(playlistID recommendations: Recommendations?) -> [String] {
        recommendations?.data.reduce(into: [String]()) {
            $0 += get(playlistID: $1.relationships.contents)
            $0 += get(playlistID: $1.relationships.recommendations)
        } ?? [String]()
    }
}
