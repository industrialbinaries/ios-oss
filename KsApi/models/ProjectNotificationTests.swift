@testable import KsApi
import XCTest

internal final class ProjectNotificationTests: XCTestCase {
  func testJSONDecoding() throws {
    let decoded = try ProjectNotification.decodeJSON([
      "id": 1,
      "email": true,
      "mobile": true,
      "project":
        [
          "id": 2,
          "name": "name"
      ]
    ]).get()

    XCTAssertEqual(1, decoded.id)
    XCTAssertEqual(true, decoded.email)
    XCTAssertEqual(true, decoded.mobile)
    XCTAssertEqual(2, decoded.project.id)
    XCTAssertEqual("name", decoded.project.name)
  }
}
