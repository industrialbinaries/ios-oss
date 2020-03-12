@testable import KsApi
import XCTest

final class UserAvatarTests: XCTestCase {
  func testJsonEncoding() throws {
    let json: [String: Any] = [
      "medium": "http://www.kickstarter.com/medium.jpg",
      "small": "http://www.kickstarter.com/small.jpg"
    ]
    let avatar = try User.Avatar.decodeJSON(json).get()

    XCTAssertEqual(avatar.medium, json["medium"] as? String)
    XCTAssertEqual(avatar.small, json["small"] as? String)
  }
}
