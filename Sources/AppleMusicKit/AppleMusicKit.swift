//
//  AppleMusicKit.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import UIKit

/// Apple Music APIの操作
public struct AppleMusicKit {
    /// デベロッパートークン
    public let developerToken: String

    /// ユーザートークン
    public var userToken: String = ""

    /// ストアの言語
    public var storefront: String = "jp"

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

    // MARK: - URL

    /// メソッド
    private enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    /// エンドポイント
    private let endPoint: String = "https://api.music.apple.com/v1"

    /// リクエストヘッダ
    private var headers: [String: String?] {
        ["Authorization": "Bearer \(developerToken)", "Music-User-Token": userToken]
    }

    /// URLRequestの取得
    /// - Parameters:
    ///   - path: URL
    ///   - method: メソッド
    ///   - headers: ヘッダ
    ///   - body: ボディー
    private func getURLRequest(path: String, method: Method = .get, body: Data? = nil) throws -> URLRequest {
        guard let url = URL(string: "\(endPoint)\(path)") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        return request
    }

    // MARK: - Song Data

    /// 曲データの検索
    /// - Note: [Get a Catalog Song | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_a_catalog_song)
    /// - Parameters:
    ///   - storeIDs: 曲ID
    /// - Returns: 曲ID (Apple MusicにあるID)
    public func searchSongs(storeIDs: [String]) async throws -> [Songs] {
        let ids = storeIDs.joined(separator: ",")
        let request = try getURLRequest(path: "/catalog/\(storefront)/songs?ids=\(ids)")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response.statusCode == 200 else {
            throw AppleMusicError.responseError(response.statusCode)
        }
        return try JSONDecoder().decode(SongResponse.self, from: data).data
    }

    /// 曲データの取得
    /// - Note: [Get a Catalog Song | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_a_catalog_song)
    /// - Parameters:
    ///   - storeIDs: 曲ID
    /// - Returns: 曲
    public func getSongData(storeID: String) async throws -> Songs {
        let request = try getURLRequest(path: "/catalog/\(storefront)/songs/\(storeID)")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response.statusCode == 200 else {
            throw AppleMusicError.responseError(response.statusCode)
        }
        let songs = try JSONDecoder().decode(SongResponse.self, from: data)
        guard let song = songs.data.first else {
            throw AppleMusicError.cantGetSong
        }
        return song
    }

    // MARK: - Storefront

    /// ストアフロントの取得
    /// - Note: [Get a Storefront | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_a_storefront)
    /// - Returns: ストアフロントID
    public func getAllStorefronts() async throws -> [Storefront] {
        let request = try getURLRequest(path: "/storefronts")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response.statusCode == 200 else {
            throw AppleMusicError.responseError(response.statusCode)
        }
        return try JSONDecoder().decode(StorefrontResponse.self, from: data).data
    }

    // MARK: - Charts

    /// チャートを取得
    /// - Note: [Get Catalog Charts | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_catalog_charts)
    /// - Parameters:
    ///   - storefront: ストアの言語
    ///   - limit: 取得件数
    /// - Returns: 曲ID
    public func getSongCharts(storefront: String = "jp", limit: Int = 20) async throws -> [Chart] {
        let request = try getURLRequest(path: "/catalog/\(storefront)/charts?types=songs&limit=\(limit)")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response.statusCode == 200 else {
            throw AppleMusicError.responseError(response.statusCode)
        }
        return try JSONDecoder().decode(ChartResponse.self, from: data).results.songs
    }

    // MARK: - Recommendations

    /// レコメンデーションのプレイリストIDの取得
    /// - Note: [Get a Recommendation | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_a_recommendation)
    /// - Returns: プレイリスト
    public func getRecommendedPlaylists() async throws -> [Recommendation] {
        guard !userToken.isEmpty else {
            throw AppleMusicError.noUserToken
        }
        let request = try getURLRequest(path: "/me/recommendations?type=playlists")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response.statusCode == 200 else {
            throw AppleMusicError.responseError(response.statusCode)
        }
        return try JSONDecoder().decode(RecommendationsResponse.self, from: data).data
    }

    // MARK: - Rating

    /// レーティングの取得
    /// - Note: [Get a Personal Song Rating | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_a_personal_song_rating)
    /// - Parameters:
    ///   - storeID: 曲ID
    /// - Returns: 結果レーティング
    public func getRating(storeID: String) async throws -> Rating {
        guard !userToken.isEmpty else {
            throw AppleMusicError.noUserToken
        }
        let request = try getURLRequest(path: "/me/ratings/songs/\(storeID)")
        let (data, response) = try await URLSession.shared.data(for: request)
        switch response.statusCode {
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
        guard !userToken.isEmpty else {
            throw AppleMusicError.noUserToken
        }
        try await delete(rating: storeID)
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
        guard !userToken.isEmpty else {
            throw AppleMusicError.noUserToken
        }
        let body = #"{"type":"rating","attributes":{"value":\#(rating.rawValue)}}"#.data(using: .utf8)
        let request = try getURLRequest(path: "/me/ratings/songs/\(storeID)", method: .put, body: body)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response.statusCode == 200 else {
            throw AppleMusicError.responseError(response.statusCode)
        }
        let rating = try JSONDecoder().decode(RatingResponse.self, from: data)
        return rating.data.first?.attributes.value ?? .neutral
    }

    /// レーティングの削除
    /// - Note: [Delete a Personal Song Rating | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/delete_a_personal_song_rating)
    /// - Parameters:
    ///   - storeID: 曲ID
    private func delete(rating storeID: String) async throws {
        guard !userToken.isEmpty else {
            throw AppleMusicError.noUserToken
        }
        let request = try getURLRequest(path: "/v1/me/ratings/songs/\(storeID)", method: .delete)
        let (_, response) = try await URLSession.shared.data(for: request)
        guard response.statusCode == 204 else {
            throw AppleMusicError.responseError(response.statusCode)
        }
    }

    // MARK: - Library

    /// ライブラリーに曲を追加
    /// - Note: [Add a Resource to a Library | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/add_a_resource_to_a_library)
    /// - Parameters:
    ///   - storeID: 曲ID
    public func addSongToLibrary(storeID: String) async throws {
        guard !userToken.isEmpty else {
            throw AppleMusicError.noUserToken
        }
        let request = try getURLRequest(path: "/me/library?ids[songs]=\(storeID)", method: .post)
        let (_, response) = try await URLSession.shared.data(for: request)
        guard response.statusCode == 202 else {
            throw AppleMusicError.responseError(response.statusCode)
        }
    }

    // MARK: - Playlist

    /// プレイリストの作成
    /// - Note: [Create a New Library Playlist | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/create_a_new_library_playlist)
    /// - Parameters:
    ///   - name: プレイリスト名
    ///   - items: 曲ID (複数)
    public func createPlaylist(name: String, items: [String]) async throws {
        guard !userToken.isEmpty else {
            throw AppleMusicError.noUserToken
        }
        let tracks = items.map { #"{"id":"\#($0)","type":"songs"}"# }.joined(separator: ",")
        let body = #"{"attributes":{"name":"\#(name)"},"relationships":{"tracks":{"data":[\#(tracks)]}}}"#.data(using: .utf8)
        let request = try getURLRequest(path: "/me/library/playlists", method: .post, body: body)
        let (_, response) = try await URLSession.shared.data(for: request)
        guard response.statusCode == 201 else {
            throw AppleMusicError.responseError(response.statusCode)
        }
    }

    /// プレイリストから曲の取得
    /// - Note: [Get a Catalog Playlist | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_a_catalog_playlist)
    /// - Parameters:
    ///   - playlistIDs: プレイリストID (複数)
    /// - Returns: 曲ID (複数)
    public func getCatalogPlaylist(_ ids: [String]) async throws -> [Playlists] {
        let playlistIDs = ids.prefix(25).joined(separator: ",")
        let request = try getURLRequest(path: "/catalog/\(storefront)/playlists?ids=\(playlistIDs)")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response.statusCode == 200 else {
            throw AppleMusicError.responseError(response.statusCode)
        }
        return try JSONDecoder().decode(PlaylistResponse.self, from: data).data
    }

    /// ユーザープレイリストの取得
    /// - Note: [Get All Library Playlists | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/get_all_library_playlists)
    /// - Returns: プレイリスト
    public func getAllLibraryPlaylists() async throws -> [LibraryPlaylists] {
        guard !userToken.isEmpty else {
            throw AppleMusicError.noUserToken
        }
        let request = try getURLRequest(path: "/me/library/playlists")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response.statusCode == 200 else {
            throw AppleMusicError.responseError(response.statusCode)
        }
        return try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data).data
    }

    /// ユーザープレイリストに曲を追加
    /// - Note: [Add Tracks to a Library Playlist | Apple Developer Documentation](https://developer.apple.com/documentation/applemusicapi/add_tracks_to_a_library_playlist)
    public func addTracks(_ tracks: [(id: String, type: MediaType)], to playlistId: String) async throws {
        guard !userToken.isEmpty else {
            throw AppleMusicError.noUserToken
        }
        let body = #"{"data":[\#(tracks.map { #"{"id":"\#($0.id)","type":"\#($0.type.rawValue)"}"# })]"#.data(using: .utf8)
        let request = try getURLRequest(path: "/me/library/playlists/\(playlistId)/tracks", method: .post, body: body)
        let (_, response) = try await URLSession.shared.data(for: request)
        guard response.statusCode == 201 else {
            throw AppleMusicError.responseError(response.statusCode)
        }
    }
}

// MARK: - URLSession extension

private extension URLSession {
    /// 通信
    /// - Parameter request: URLリクエスト
    /// - Returns: (結果, レスポンス)
    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        if #available(iOS 15, *) {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            return (data, response)
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard error == nil else {
                        continuation.resume(throwing: error!)
                        return
                    }
                    guard let data, let response = response as? HTTPURLResponse else {
                        continuation.resume(throwing: URLError(.badServerResponse))
                        return
                    }
                    continuation.resume(returning: (data, response))
                }.resume()
            }
        }
    }
}
