//
//  AppleMusicError.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

public enum AppleMusicError: LocalizedError {
    case responseError(Int)
	case noUserToken
	case notAutholized
    case cantGetTheArtwork
    case failureToSetTheRating
    case unknown

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
