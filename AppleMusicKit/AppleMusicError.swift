//
//  AppleMusicError.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

/// エラー
public enum AppleMusicError: LocalizedError {
    /// 不正なレスポンス
    case responseError(Int)

    /// トークンが取得できない
	case noUserToken

    /// 認証されていない
	case notAutholized

    /// アートワークが取得できない
    case cantGetTheArtwork

    /// レーティングの設定に失敗する
    case failureToSetTheRating

    /// 不明なエラー
    case unknown

    // MARK: -

    /// エラーコメント
    public var errorDescription: String? {
        switch self {
        case .responseError(let code):
            return String(format: NSLocalizedString("Response error (%d)", comment: ""), code)
        case .noUserToken:
            return NSLocalizedString("Can't get token", comment: "")
        case .notAutholized:
            return NSLocalizedString("Not autholized", comment: "")
        case .cantGetTheArtwork:
            return NSLocalizedString("Can't get the artwork", comment: "")
        case .failureToSetTheRating:
            return NSLocalizedString("Failure to set the rating", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "")
        }
    }
}
