import Foundation

public struct FriendStatsEnvelope {
  public let stats: Stats

  public struct Stats {
    public let friendProjectsCount: Int
    public let remoteFriendsCount: Int
  }
}

extension FriendStatsEnvelope: Decodable {}

extension FriendStatsEnvelope.Stats: Decodable {
  enum CodingKeys: String, CodingKey {
    case friendProjectsCount = "friend_projects_count"
    case remoteFriendsCount = "remote_friends_count"
  }
}
