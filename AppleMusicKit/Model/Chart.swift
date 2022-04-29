//
//  Chart.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/04
//

import Foundation

struct ChartResponse: Codable {
    let results: Results

    var ids: [String] {
        results.songs.reduce(into: [String]()) {
            $0 += $1.data.map { $0.id }
        }
    }

    struct Results: Codable {
        let songs: [Chart]
    }
}

struct Chart: Codable {
    let chart: String
    let data: [Song]
    let href: String
    let name: String
    let next: String
}
