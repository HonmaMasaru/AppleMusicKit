//
//  Rating.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

/// レーティングのレスポンス
/// - Note: [RatingsResponse | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/ratingsresponse)
struct RatingResponse: Codable {
    /// 問い合わせ結果
    let data: [Data]

    /// レーティングデータ
    struct Data: Codable {
        let type: String
        let attributes: Attributes
    }

    /// 属性
    /// - Note: [Ratings.Attributes | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/ratings/attributes)
    struct Attributes: Codable {
        /// レーティング
        let value: Rating
    }
}

// MARK: -

/// レーティング
/// - Note: [Ratings | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/ratings-ulo)
public enum Rating: Int, Codable {
    case like = 1
    case neutral = 0
    case dislike = -1
}
