//
//  AppleMusicKitTests.swift
//  AppleMusicKitTests
//
//  Created by Honma Masaru on 2022/05/05.
//  Copyright © 2022 Signpost. All rights reserved.
//

import XCTest
import AppleMusicKit

final class AppleMusicKitTests: XCTestCase {
    // デベロッパートークン
    private let developerToken = ""

    // AppleMusicKit
    private var appleMusicKit: AppleMusicKit!

    override func setUp() {
        appleMusicKit = .init(developerToken: developerToken, userToken: "", storefront: "jp")
    }

    // MARK: - Storefront

    func testGetAllStorefronts() {
        Task {
            do {
                let storefronts = try await appleMusicKit.getAllStorefronts()
                XCTAssertTrue(storefronts.count > 0)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }

    // MARK: - Charts

    func testGetCharts() {
        Task {
            do {
                let charts = try await appleMusicKit.getSongCharts()
                XCTAssertGreaterThan(charts.count, 0)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
}
