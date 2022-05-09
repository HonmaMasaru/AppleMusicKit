//
//  AppleMusicAPI.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import UIKit

public struct AppleMusicAPI {

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
    /// - Parameters:
    ///   - storeIDs: 曲ID
    ///   - completion: 結果
    public func searchSongs(storeIDs: [String], completion: @escaping (Result<[String], Error>) -> Void) {
        let ids = storeIDs.joined(separator: ",")
        guard let url = URL(string: "https://api.music.apple.com/v1/catalog/\(storefront)/songs?ids=\(ids)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard error == nil else { throw error! }
                guard let r = response as? HTTPURLResponse, data != nil else { throw URLError(.badServerResponse) }
                guard r.statusCode == 200 else { throw AppleMusicError.responseError(r.statusCode) }
                let song = try JSONDecoder().decode(SongResponse.self, from: data!)
                completion(.success(song.ids))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    /// 曲データの取得
    /// - Parameters:
    ///   - storeIDs: 曲ID
    ///   - completion: 結果
    public func getSongData(storeID: String, completion: @escaping (Result<Song, Error>) -> Void) {
        guard let url = URL(string: "https://api.music.apple.com/v1/catalog/\(storefront)/songs/\(storeID)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard error == nil else { throw error! }
                guard let r = response as? HTTPURLResponse, data != nil else { throw URLError(.badServerResponse) }
                guard r.statusCode == 200 else { throw AppleMusicError.responseError(r.statusCode) }
                let songs = try JSONDecoder().decode(SongResponse.self, from: data!)
                completion(.success(songs.data[0]))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // MARK: - Storefront

    /// ストアフロントの取得
    /// - Parameter completion: 結果
    public func getAllStorefronts(completion: @escaping (Result<[Storefront], Error>) -> Void) {
        guard let url = URL(string: "https://api.music.apple.com/v1/storefronts") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard error == nil else { throw error! }
                guard let r = response as? HTTPURLResponse, data != nil else { throw URLError(.badServerResponse) }
                guard r.statusCode == 200 else { throw AppleMusicError.responseError(r.statusCode) }
                let storeFronts = try JSONDecoder().decode(StorefrontResponse.self, from: data!)
                completion(.success(storeFronts.data))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // MARK: - Charts

    /// チャートを取得
    /// - Parameters:
    ///   - storefront: ストアの言語
    ///   - limit: 取得件数
    ///   - completion: 結果
    public func getCharts(storefront: String = "jp", limit: Int = 20, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: "https://api.music.apple.com/v1/catalog/\(storefront)/charts?types=songs&limit=\(limit)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard error == nil else { throw error! }
                guard let r = response as? HTTPURLResponse, data != nil else { throw URLError(.badServerResponse) }
                guard r.statusCode == 200 else { throw AppleMusicError.responseError(r.statusCode) }
                let chart = try JSONDecoder().decode(ChartResponse.self, from: data!)
                completion(.success(chart.ids))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // MARK: - Recommendations

    /// レコメンデーションのプレイリストIDの取得
    /// - Parameter completion: 結果
    public func getRecommendedPlaylists(completion: @escaping (Result<[String], Error>) -> Void) {
        guard !userToken.isEmpty else {
            completion(.failure(AppleMusicError.noUserToken))
            return
        }
        guard let url = URL(string: "https://api.music.apple.com/v1/me/recommendations?type=playlists") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard error == nil else { throw error! }
                guard let r = response as? HTTPURLResponse, data != nil else { throw URLError(.badServerResponse) }
                guard r.statusCode == 200 else { throw AppleMusicError.responseError(r.statusCode) }
                let recommend = try JSONDecoder().decode(RecommendationsResponse.self, from: data!)
                completion(.success(recommend.ids))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // MARK: - Rating

    /// レーティングの取得
    /// - Parameters:
    ///   - storeID: 曲ID
    ///   - completion: 結果
    public func getRating(storeID: String, completion: @escaping (Result<Rating, Error>) -> Void) {
        guard !userToken.isEmpty else {
            completion(.failure(AppleMusicError.noUserToken))
            return
        }
        guard let url = URL(string: "https://api.music.apple.com/v1/me/ratings/songs/\(storeID)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard error == nil else { throw error! }
                guard let res = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
                if case 200 = res.statusCode, data != nil {
                    let rating = try JSONDecoder().decode(RatingResponse.self, from: data!)
                    completion(.success(rating.data[0].attributes.value))
                } else if case 404 = res.statusCode {
                    completion(.success(.neutral))
                } else {
                    throw URLError(.badServerResponse)
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    /// レーティングを設定
    /// - Parameters:
    ///   - rating: レーティング
    ///   - storeID: 曲ID
    ///   - completion: 結果
    public func set(rating: Rating, storeID: String, completion: @escaping (Result<Rating, Error>) -> Void) {
        guard !userToken.isEmpty else {
            completion(.failure(AppleMusicError.noUserToken))
            return
        }
        deleteRating(storeID: storeID) { error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            switch rating {
            case .like:
                self.put(rating: .like, storeID: storeID, completion: completion)
            case .dislike:
                self.put(rating: .dislike, storeID: storeID, completion: completion)
            case .neutral:
                completion(.success(.neutral))
            }
        }
    }

    /// レーティングを送信
    /// - Parameters:
    ///   - rating: レーティング
    ///   - storeID: 曲ID
    ///   - completion: 結果
    private func put(rating: Rating, storeID: String, completion: @escaping (Result<Rating, Error>) -> Void) {
        guard let url = URL(string: "https://api.music.apple.com/v1/me/ratings/songs/\(storeID)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let body = #"{"type":"rating","attributes":{"value":\#(rating.rawValue)}}"#
        let request = URLRequest(url: url, method: .put, headers: headers, body: body.data(using: .utf8))
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard error == nil else { throw error! }
                guard let res = response as? HTTPURLResponse, data != nil else { throw URLError(.badServerResponse) }
                guard res.statusCode == 200 else { throw AppleMusicError.responseError(res.statusCode) }
                let rating = try JSONDecoder().decode(RatingResponse.self, from: data!)
                completion(.success(rating.data[0].attributes.value))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    /// レーティングの削除
    /// - Parameters:
    ///   - storeID: 曲ID
    ///   - completion: 結果
    private func deleteRating(storeID: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://api.music.apple.com/v1/me/ratings/songs/\(storeID)") else {
            completion(URLError(.badURL))
            return
        }
        let request = URLRequest(url: url, method: .delete, headers: headers)
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            do {
                guard error == nil else { throw error! }
                guard let r = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
                guard r.statusCode == 204 else { throw AppleMusicError.responseError(r.statusCode) }
                completion(nil)
            } catch {
                completion(error)
            }
        }
        task.resume()
    }

    // MARK: - Library

    /// ライブラリーに曲を追加
    /// - Parameters:
    ///   - storeID: 曲ID
    ///   - completion: 結果
    public func addSongToLibrary(storeID: String, completion: @escaping (Error?) -> Void) {
        guard !userToken.isEmpty else {
            completion(AppleMusicError.noUserToken)
            return
        }
        guard let url = URL(string: "https://api.music.apple.com/v1/me/library?ids[songs]=\(storeID)") else {
            completion(URLError(.badURL))
            return
        }
        let request = URLRequest(url: url, method: .post, headers: headers)
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            do {
                guard error == nil else { throw error! }
                guard let r = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
                guard r.statusCode == 202 else { throw AppleMusicError.responseError(r.statusCode) }
                completion(nil)
            } catch {
                completion(error)
            }
        }
        task.resume()
    }

    // MARK: - Playlist

    /// プレイリストの作成
    /// - Parameters:
    ///   - name: プレイリスト名
    ///   - storeID: 曲ID (複数)
    ///   - completion: 結果
    public func createNewPlaylist(name: String, storeIDs: [String], completion: @escaping (Error?) -> Void) {
        guard !userToken.isEmpty else {
            completion(AppleMusicError.noUserToken)
            return
        }
        guard let url = URL(string: "https://api.music.apple.com/v1/me/library/playlists") else {
            completion(URLError(.badURL))
            return
        }
        let storeIDs = storeIDs.map { #"{"id":"\#($0)","type":"songs"}"# }.joined(separator: ",")
        let body = #"{"attributes":{"name":"\#(name)"},"relationships":{"tracks":{"data":[\#(storeIDs)]}}}"#
        let request = URLRequest(url: url, method: .post, headers: headers, body: body.data(using: .utf8))
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            do {
                guard error == nil else { throw error! }
                guard let r = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
                guard r.statusCode == 201 else { throw AppleMusicError.responseError(r.statusCode) }
                completion(nil)
            } catch {
                completion(error)
            }
        }
        task.resume()
    }

    /// プレイリストから曲の取得
    /// - Parameters:
    ///   - playlistIDs: プレイリストID (複数)
    ///   - completion: 結果
    public func getSongsFromPlaylists(playlistIDs: [String], completion: @escaping (Result<[String], Error>) -> Void) {
        let ids = playlistIDs.prefix(25).joined(separator: ",")
        guard let url = URL(string: "https://api.music.apple.com/v1/catalog/\(storefront)/playlists?ids=\(ids)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url, method: .get, headers: headers)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard error == nil else { throw error! }
                guard let res = response as? HTTPURLResponse, data != nil else { throw URLError(.badServerResponse) }
                guard res.statusCode == 200 else { throw AppleMusicError.responseError(res.statusCode) }
                let playlists = try JSONDecoder().decode(PlaylistResponse.self, from: data!)
                completion(.success(playlists.ids))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
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
