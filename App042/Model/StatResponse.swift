// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let statResponse = try? JSONDecoder().decode(StatResponse.self, from: jsonData)

import Foundation

// MARK: - StatResponse
struct StatResponse: Codable {
    let userStats: UserStats?
    let detail: String?
    let videoStats: [VideoStat]?
    
    enum CodingKeys: String, CodingKey {
        case userStats = "user_stats"
        case videoStats = "video_stats"
        case detail
    }
}

// MARK: - UserStats
struct UserStats: Codable {
    let createdAt: String?
    let followers, following, likes, diggs: Int?
    let nickname: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case followers, following, likes, diggs, nickname
    }
}

struct VideoStat: Codable {
    let videoID: String?
    let views, comments, diggs, shares: Int?
    let nickname: String?
    let videoURL, coverURL: String?

    enum CodingKeys: String, CodingKey {
        case videoID = "video_id"
        case views, comments, diggs, shares, nickname
        case videoURL = "video_url"
        case coverURL = "cover_url"
    }
}
