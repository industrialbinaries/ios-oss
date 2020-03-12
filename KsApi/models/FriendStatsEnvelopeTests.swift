@testable import KsApi
import XCTest

final class FriendStatsEnvelopeTests: XCTestCase {
  func testJsonDecoding() throws {
    let json: [String: Any] = [
      "stats": [
        "remote_friends_count": 202,
        "friend_projects_count": 1_132
      ]
    ]

    let stats = try FriendStatsEnvelope.decodeJSON(json)
      .get()
      .stats

    XCTAssertEqual(202, stats.remoteFriendsCount)
    XCTAssertEqual(1_132, stats.friendProjectsCount)
  }
}
