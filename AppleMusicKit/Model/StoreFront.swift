//
//  Storefront.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/04
//

import Foundation

/// ストアフロントのレスポンス
/// https://developer.apple.com/documentation/applemusicapi/storefrontsresponse
struct StorefrontResponse: Codable {
    /// 問い合わせ結果
    let data: [Storefront]
}

// MARK: -

/// ストアフロント
/// https://developer.apple.com/documentation/applemusicapi/storefronts
public struct Storefront: Codable, Identifiable {
    /// ID
    public let id: String

    /// 関連項目
    public let attributes: Attributes

    /// 関連項目
    /// https://developer.apple.com/documentation/applemusicapi/storefronts/attributes
    public struct Attributes: Codable {
        /// ストアフロント (ローカライズ)
        public let name: String
    }
}
