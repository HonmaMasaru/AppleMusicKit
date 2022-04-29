//
//  Rating.swift
//  AppleMusicKit
//
//  Created by 本間 on 2020/05/03
//

import Foundation

public enum Rating: Int, Codable {
	case like = 1
	case neutral = 0
	case dislike = -1
}

struct RatingResponse: Codable {
	let data: [Data]

	struct Data: Codable {
		let type: String
		let attributes: Attributes
	}

    struct Attributes: Codable {
        let value: Rating
    }
}
