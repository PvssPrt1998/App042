import Foundation

// MARK: - StoreUserResponse
struct UserResponse: Codable {
    let id: Int?
    let nickname, avatar: String?
    let detail: String?
}
