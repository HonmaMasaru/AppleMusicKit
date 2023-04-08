//
//  AppleMusicError.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

/// エラー
public enum AppleMusicError {
    /// 不正なレスポンス
    case responseError(Int)

    /// トークンが取得できない
    case noUserToken

    /// 認証されていない
    case notAutholized

    /// 曲が取得できない
    case cantGetSong

    /// アートワークが取得できない
    case cantGetArtwork

    /// レーティングの設定に失敗する
    case failureToSetRating

    /// 不明なエラー
    case unknown
}

// MARK: -

extension AppleMusicError: LocalizedError {
    /// エラーコメント
    public var errorDescription: String? {
        switch self {
        case .responseError(let code):
            return String(format: NSLocalizedString("Response error (%d)", comment: ""), code)
        case .noUserToken:
            return NSLocalizedString("Can't get token", comment: "")
        case .notAutholized:
            return NSLocalizedString("Not autholized", comment: "")
        case .cantGetSong:
            return NSLocalizedString("Can't get song", comment: "")
        case .cantGetArtwork:
            return NSLocalizedString("Can't get the artwork", comment: "")
        case .failureToSetRating:
            return NSLocalizedString("Failure to set the rating", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "")
        }
    }
}
