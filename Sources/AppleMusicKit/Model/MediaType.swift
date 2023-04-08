//
//  MediaType.swift
//  AppleMusicKit
//
//  Created by Honma Masaru on 2023/04/08.
//

import Foundation

/// メディアタイプ
public enum MediaType: String, Codable {
    case libraryMusicVideos = "library-music-videos"
    case librarySongs = "library-songs"
    case musicVideos = "music-videos"
    case songs = "songs"
}
