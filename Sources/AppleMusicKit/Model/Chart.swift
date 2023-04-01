//
//  Chart.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/04
//

import Foundation

/// チャートのレスポンス
/// - Note: [ChartResponse | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/chartresponse)
struct ChartResponse: Codable {
    /// 問い合わせ結果
    let results: Results

    /// 結果データ
    /// - Note: [ChartResponse.Results | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/chartresponse/results)
    struct Results: Codable {
        /// 曲データ
        let songs: [Chart]
    }

    // MARK: -

    /// IDの取得
    var ids: [String] {
        results.songs.reduce(into: [String]()) {
            $0 += $1.data.map { $0.id }
        }
    }
}

// MARK: -

/// チャート (曲)
/// - Note: [ChartResponse.Results.SongsChart | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/chartresponse/results/songschart)
struct Chart: Codable {
    /// チャート名
    let chart: String

    /// 曲のデータ
    let data: [Songs]

    /// チャートデータのURL
    let href: String?

    /// チャート名 (ローカライズ)
    let name: String

    /// 次の検索結果
    let next: String
}
