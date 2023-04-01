//
//  AppleMusicKit.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import UIKit

public struct AppleMusicKit {
    /// デベロッパートークン
    public let developerToken: String

    /// ユーザートークン
    public var userToken: String = ""

    /// ストアの言語
    public var storefront: String = "jp"

    /// リクエストヘッダ
    private var headers: [String: String?] {
        ["Authorization": "Bearer \(developerToken)", "Music-User-Token": userToken]
    }

    // MARK: - Init

    /// 初期化
    /// - Parameters:
    ///   - developerToken: デベロッパートークン
    ///   - userToken: ユーザートークン
    ///   - storefront: ストアの言語
    public init(developerToken: String, userToken: String, storefront: String) {
        self.developerToken = developerToken
        self.userToken = userToken
        self.storefront = storefront
    }

    // MARK: - Song Data

    /// 曲データの検索
    /// - Note: [Get a Catalog Song | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_a_catalog_song)
    /// - Parameters:
    ///   - storeIDs: 曲ID
    /// - Returns: 曲ID (Apple MusicにあるID)
    public func searchSongs(storeIDs: [String]) async throws -> [String] {
        let ids = storeIDs.joined(separator: ",")
        guard let url = URL(string: "https://api.music.apple.com/v1/catalog/\(storefront)/songs?ids=\(ids)") else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let res = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard res.statusCode == 200 else { throw AppleMusicError.responseError(res.statusCode) }
        let song = try JSONDecoder().decode(SongResponse.self, from: data)
        return song.ids
    }

    /// 曲データの取得
    /// - Note: [Get a Catalog Song | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_a_catalog_song)
    /// - Parameters:
    ///   - storeIDs: 曲ID
    /// - Returns: 曲
    public func getSongData(storeID: String) async throws -> Songs {
        guard let url = URL(string: "https://api.music.apple.com/v1/catalog/\(storefront)/songs/\(storeID)") else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let res = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard res.statusCode == 200 else { throw AppleMusicError.responseError(res.statusCode) }
        let songs = try JSONDecoder().decode(SongResponse.self, from: data)
        guard let song = songs.data.first else { throw AppleMusicError.cantGetTheSong }
        return song
    }

    // MARK: - Storefront

    /// ストアフロントの取得
    /// - Note: [Get a Storefront | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_a_storefront)
    /// - Returns: ストアフロントID
    public func getAllStorefronts() async throws -> [Storefront] {
        guard let url = URL(string: "https://api.music.apple.com/v1/storefronts") else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let res = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard res.statusCode == 200 else { throw AppleMusicError.responseError(res.statusCode) }
        let storeFronts = try JSONDecoder().decode(StorefrontResponse.self, from: data)
        return storeFronts.data
    }

    // MARK: - Charts

    /// チャートを取得
    /// - Note: [Get Catalog Charts | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_catalog_charts)
    /// - Parameters:
    ///   - storefront: ストアの言語
    ///   - limit: 取得件数
    /// - Returns: 曲ID
    public func getCharts(storefront: String = "jp", limit: Int = 20) async throws -> [String] {
        guard let url = URL(string: "https://api.music.apple.com/v1/catalog/\(storefront)/charts?types=songs&limit=\(limit)") else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let res = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard res.statusCode == 200 else { throw AppleMusicError.responseError(res.statusCode) }
        let chart = try JSONDecoder().decode(ChartResponse.self, from: data)
        return chart.ids
    }

    // MARK: - Recommendations

    /// レコメンデーションのプレイリストIDの取得
    /// - Note: [Get a Recommendation | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_a_recommendation)
    /// - Returns: プレイリストID (複数)
    public func getRecommendedPlaylists() async throws -> [String] {
        guard !userToken.isEmpty else { throw AppleMusicError.noUserToken }
        guard let url = URL(string: "https://api.music.apple.com/v1/me/recommendations?type=playlists") else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let res = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard res.statusCode == 200 else { throw AppleMusicError.responseError(res.statusCode) }
        let recommend = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
        return recommend.ids
    }

    // MARK: - Rating

    /// レーティングの取得
    /// - Note: [Get a Personal Song Rating | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_a_personal_song_rating)
    /// - Parameters:
    ///   - storeID: 曲ID
    /// - Returns: 結果レーティング
    public func getRating(storeID: String) async throws -> Rating {
        guard !userToken.isEmpty else { throw AppleMusicError.noUserToken }
        guard let url = URL(string: "https://api.music.apple.com/v1/me/ratings/songs/\(storeID)") else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let res = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        switch res.statusCode {
        case 200:
            let rating = try JSONDecoder().decode(RatingResponse.self, from: data)
            return rating.data.first?.attributes.value ?? .neutral
        case 404:
            return .neutral
        default:
            throw URLError(.badServerResponse)
        }
    }

    /// レーティングを設定
    /// - Parameters:
    ///   - rating: レーティング
    ///   - storeID: 曲ID
    /// - Returns: 結果レーティング
    public func set(rating: Rating, storeID: String) async throws -> Rating {
        guard !userToken.isEmpty else { throw AppleMusicError.noUserToken }
        try await deleteRating(storeID: storeID)
        if rating == .like || rating == .dislike {
            return try await put(rating: rating, storeID: storeID)
        }
        return .neutral
    }

    /// レーティングを送信
    /// - Note: [Add a Personal Song Rating | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/add_a_personal_song_rating)
    /// - Parameters:
    ///   - rating: レーティング
    ///   - storeID: 曲ID
    /// - Returns: 結果レーティング
    private func put(rating: Rating, storeID: String) async throws -> Rating {
        guard let url = URL(string: "https://api.music.apple.com/v1/me/ratings/songs/\(storeID)") else {
            throw URLError(.badURL)
        }
        let body = #"{"type":"rating","attributes":{"value":\#(rating.rawValue)}}"#
        let request = URLRequest(url: url, method: .put, headers: headers, body: body.data(using: .utf8))
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let res = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard res.statusCode == 200 else { throw AppleMusicError.responseError(res.statusCode) }
        let rating = try JSONDecoder().decode(RatingResponse.self, from: data)
        return rating.data.first?.attributes.value ?? .neutral
    }

    /// レーティングの削除
    /// - Note: [Delete a Personal Song Rating | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/delete_a_personal_song_rating)
    /// - Parameters:
    ///   - storeID: 曲ID
    private func deleteRating(storeID: String) async throws {
        guard let url = URL(string: "https://api.music.apple.com/v1/me/ratings/songs/\(storeID)") else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url, method: .delete, headers: headers)
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let res = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard res.statusCode == 204 else { throw AppleMusicError.responseError(res.statusCode) }
    }

    // MARK: - Library

    /// ライブラリーに曲を追加
    /// - Note: [Add a Resource to a Library | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/add_a_resource_to_a_library)
    /// - Parameters:
    ///   - storeID: 曲ID
    public func addSongToLibrary(storeID: String) async throws {
        guard !userToken.isEmpty else { throw AppleMusicError.noUserToken }
        guard let url = URL(string: "https://api.music.apple.com/v1/me/library?ids[songs]=\(storeID)") else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url, method: .post, headers: headers)
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let res = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard res.statusCode == 202 else { throw AppleMusicError.responseError(res.statusCode) }
    }

    // MARK: - Playlist

    /// プレイリストの作成
    /// - Note: [Create a New Library Playlist | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/create_a_new_library_playlist)
    /// - Parameters:
    ///   - name: プレイリスト名
    ///   - items: 曲ID (複数)
    public func createPlaylist(name: String, items: [String]) async throws {
        guard !userToken.isEmpty else { throw AppleMusicError.noUserToken }
        guard let url = URL(string: "https://api.music.apple.com/v1/me/library/playlists") else {
            throw URLError(.badURL)
        }
        let tracks = items.map { #"{"id":"\#($0)","type":"songs"}"# }.joined(separator: ",")
        let body = #"{"attributes":{"name":"\#(name)"},"relationships":{"tracks":{"data":[\#(tracks)]}}}"#
        let request = URLRequest(url: url, method: .post, headers: headers, body: body.data(using: .utf8))
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let res = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard res.statusCode == 201 else { throw AppleMusicError.responseError(res.statusCode) }
    }

    /// プレイリストから曲の取得
    /// - Note: [Get a Catalog Playlist | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_a_catalog_playlist)
    /// - Parameters:
    ///   - playlistIDs: プレイリストID (複数)
    /// - Returns: 曲ID (複数)
    public func getSongsFromPlaylists(playlistIDs: [String]) async throws -> [String] {
        let ids = playlistIDs.prefix(25).joined(separator: ",")
        guard let url = URL(string: "https://api.music.apple.com/v1/catalog/\(storefront)/playlists?ids=\(ids)") else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let res = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard res.statusCode == 200 else { throw AppleMusicError.responseError(res.statusCode) }
        let playlists = try JSONDecoder().decode(PlaylistResponse.self, from: data)
        return playlists.ids
    }
}

// MARK: -

private extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if #available(iOS 15, *) {
            return try await URLSession.shared.data(for: request, delegate: nil)
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard error == nil else {
                        continuation.resume(with: .failure(error!))
                        return
                    }
                    guard data != nil, response != nil else {
                        continuation.resume(with: .failure(URLError(.badServerResponse)))
                        return
                    }
                    continuation.resume(with: .success((data!, response!)))
                }.resume()
            }
        }
    }
}

// MARK: -

private extension URLRequest {
    /// メソッド
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    /// 初期化
    /// - Parameters:
    ///   - url: URL
    ///   - method: メソッド
    ///   - headers: ヘッダ
    ///   - body: ボディー
    init(url: URL, method: Method, headers: [String: String?]? = nil, body: Data? = nil) {
        self.init(url: url)
        httpMethod = method.rawValue
        httpBody = body
        headers?.forEach { setValue($0.value, forHTTPHeaderField: $0.key) }
    }
}
