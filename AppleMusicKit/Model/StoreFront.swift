//
//  Storefront.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/04
//

import Foundation

struct StorefrontResponse: Codable {
    let data: [Storefront]
}

public struct Storefront: Codable, Identifiable {
    public let id: String
    public let attributes: Attributes

    public struct Attributes: Codable {
        public let name: String
    }
}
