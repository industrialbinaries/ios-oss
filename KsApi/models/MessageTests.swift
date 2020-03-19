@testable import KsApi
import XCTest

internal final class MessageTests: XCTestCase {
  func testDecoding() throws {
    let message = try Message.decodeJSON([
      "body": "Hello!",
      "created_at": 123_456_789.0,
      "id": 1,
      "recipient": [
        "id": 1,
        "name": "Blob",
        "avatar": [
          "medium": "img",
          "small": "img"
        ]
      ],
      "sender": [
        "id": 2,
        "name": "Clob",
        "avatar": [
          "medium": "img",
          "small": "img"
        ]
      ]
      ]).get()

    XCTAssertNotNil(message)
    XCTAssertEqual("Hello!", message.body)
    XCTAssertEqual(1, message.id)
    XCTAssertEqual(1, message.recipient.id)
    XCTAssertEqual(2, message.sender.id)
  }
}
