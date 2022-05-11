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

    // 曲ID
    private let songID = (success: "36954", fail: "abcde")

    override func setUp() {
        appleMusicKit = AppleMusicKit(developerToken: developerToken, userToken: "", storefront: "jp")
    }

    // MARK: - 曲データの検索

    // 成功
    func testSearchSongsSuccess() {
        Task {
            do {
                let ids = try await appleMusicKit.searchSongs(storeIDs: [songID.success])
                XCTAssertEqual(ids.first, songID.success)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }

    // 失敗
    func testSearchSongsFail() {
        Task {
            do {
                let ids = try await appleMusicKit.searchSongs(storeIDs: [songID.fail])
                XCTFail(ids.first ?? "")
            } catch {
                XCTAssertNotNil(error)
            }
        }
    }

    // MARK: - 曲データの取得

    // 成功
    func testGetSongDataSuccess() {
        Task {
            do {
                let song = try await appleMusicKit.getSongData(storeID: songID.success)
                XCTAssertEqual(song.id, self.songID.success)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }

    // 失敗
    func testGetSongDataFail() {
        Task {
            do {
                let song = try await appleMusicKit.getSongData(storeID: songID.fail)
                XCTFail(song.id)
            } catch {
                XCTAssertNotNil(error)
            }
        }
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
                let charts = try await appleMusicKit.getCharts()
                XCTAssertTrue(charts.count > 0)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
}
