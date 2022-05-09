//
//  Storefront.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/04
//

import Foundation

/// ストアフロントのレスポンス
/// - Note: [StorefrontsResponse | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/storefrontsresponse)
struct StorefrontResponse: Codable {
    /// 問い合わせ結果
    let data: [Storefront]
}

// MARK: -

/// ストアフロント
/// - Note: [Storefronts | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/storefronts)
public struct Storefront: Codable, Identifiable {
    /// ID
    public let id: String

    /// 関連項目
    public let attributes: Attributes

    /// 関連項目
    /// - Note: [Storefronts.Attributes | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/storefronts/attributes)
    public struct Attributes: Codable {
        /// ストアフロント (ローカライズ)
        public let name: String
    }
}
