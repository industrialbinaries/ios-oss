@testable import KsApi
import XCTest

internal final class ProjectActivityEnvelopeTests: XCTestCase {

  func testJSONDecoding() throws {
    let envelope = try ProjectActivityEnvelope.decodeJSON([
      "activities": [
        [
          "category": "update",
          "created_at": 123_123_123,
          "id": 3
        ]
      ],
      "urls": [
        "api": [
          "more_activities": "test"
        ]
      ]
    ]).get()

    XCTAssertEqual("test", envelope.urls.api.moreActivities)
    XCTAssertEqual(1, envelope.activities.count)
    XCTAssertEqual(3, envelope.activities.first?.id)
  }

  func testJSONDecoding_withoutActivities() throws {
    let envelope = try ActivityEnvelope.decodeJSON([
      "activities": [],
      "urls": [
        "api": [:]
      ]
      ]).get()

    XCTAssertEqual("", envelope.urls.api.moreActivities)
  }
}
