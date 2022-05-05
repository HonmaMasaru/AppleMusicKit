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

    // AppleMusicAPI
    private var appleMusicAPI: AppleMusicAPI!

    // 曲ID
    private let songID = (success: "36954", fail: "abcde")

    override func setUp() {
        appleMusicAPI = AppleMusicAPI(developerToken: developerToken, userToken: "", storefront: "jp")
    }

    // MARK: - 曲データの検索

    // 成功
    func testSearchSongsSuccess() {
        appleMusicAPI.searchSongs(storeIDs: [songID.success]) {
            switch $0 {
            case .success(let ids):
                XCTAssertEqual(ids.first, self.songID.success)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }

    // 失敗
    func testSearchSongsFail() {
        appleMusicAPI.searchSongs(storeIDs: [songID.fail]) {
            switch $0 {
            case .success(let ids):
                XCTFail(ids.first ?? "")
            case .failure(let error):
                print(error.localizedDescription)
                XCTAssertNotNil(error)
            }
        }
    }

    // MARK: - 曲データの取得

    // 成功
    func testGetSongDataSuccess() {
        appleMusicAPI.getSongData(storeID: songID.success) {
            switch $0 {
            case .success(let song):
                Swift.print(song.attributes.name)
                XCTAssertEqual(song.id, self.songID.success)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }

    // 失敗
    func testGetSongDataFail() {
        appleMusicAPI.getSongData(storeID: songID.fail) {
            switch $0 {
            case .success(let ids):
                XCTFail(ids.id)
            case .failure(let error):
                print(error.localizedDescription)
                XCTAssertNotNil(error)
            }
        }
    }

    // MARK: - Storefront

    func testGetAllStorefronts() {
        appleMusicAPI.getAllStorefronts {
            switch $0 {
            case .success(let storefronts):
                XCTAssertTrue(storefronts.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }

    // MARK: - Charts

    func testGetCharts() {
        appleMusicAPI.getCharts {
            switch $0 {
            case .success(let charts):
                XCTAssertTrue(charts.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
}
