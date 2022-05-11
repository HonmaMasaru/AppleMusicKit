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

    /// IDの取得
    var ids: [String] {
        data.reduce(into: [String]()) { $0 += $1.ids }
    }
}

// MARK: -

/// レコメンド
/// - Note: [PersonalRecommendation | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/personalrecommendation)
struct Recommendation: Codable {
    /// 関連項目
    let relationships: Relationships

    /// 関連項目
    /// - Note: [PersonalRecommendation.Relationships | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/personalrecommendation/relationships)
    struct Relationships: Codable {
        /// コンテンツ
        let contents: Contents?

        /// レコメンド
        let recommendations: Recommendations?
    }

    /// コンテンツ
    /// - Note: [PersonalRecommendation.Relationships.PersonalRecommendationContentsRelationship | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/personalrecommendation/relationships/personalrecommendationcontentsrelationship)
    struct Contents: Codable {
        /// リソース
        let data: [Resource]
    }

    /// リソース
    /// - Note: [Resource | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/resource)
    struct Resource: Codable {
        /// ID
        let id: String

        /// タイプ
        let type: String
    }

    /// レコメンド
    struct Recommendations: Codable {
        /// レコメンド内容
        let data: [Recommendation]
    }

    // MARK: -

    /// IDの取得
    fileprivate var ids: [String] {
        var ids = get(playlistID: relationships.contents)
        ids += get(playlistID: relationships.recommendations)
        return ids
    }

    /// プレイリストから曲IDを取得
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
