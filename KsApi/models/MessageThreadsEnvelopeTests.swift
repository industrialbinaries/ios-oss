@testable import KsApi
import XCTest

final class MessageThreadsEnvelopeTests: XCTestCase {
  func testDecoding() throws {
    let result = try MessageThreadsEnvelope.decodeJSON([
      "message_threads": [],
      "urls": [
        "api": [
          "more_message_threads": "test"
        ]
      ],
    ]).get()

    XCTAssertEqual("test", result.urls.api.moreMessageThreads)
    XCTAssertEqual(0, result.messageThreads.count)
  }
}
