@testable import KsApi
import XCTest

final class PushEnvelopeTests: XCTestCase {
  func testDecode_Update_WithUpdateKey() throws {
    let envelope = try PushEnvelope.decodeJSON([
      "aps": [
        "alert": "Hi"
      ],
      "update": [
        "id": 1,
        "project_id": 2
      ],
      ]).get()

    XCTAssertNotNil(envelope.update)
    XCTAssertEqual(1, envelope.update?.id)
    XCTAssertEqual(2, envelope.update?.projectId)
  }

  func testDecode_Update_WithPostKey() throws {
    let envelope = try PushEnvelope.decodeJSON([
      "aps": [
        "alert": "Hi"
      ],
      "post": [
        "id": 1,
        "project_id": 2
      ]
      ]).get()

    XCTAssertNotNil(envelope.update)
    XCTAssertEqual(1, envelope.update?.id)
    XCTAssertEqual(2, envelope.update?.projectId)
  }

  func testDecode() throws {
    let envelope = try PushEnvelope.decodeJSON([
      "aps": [
        "alert": "Hi"
      ],
      "update": [
        "id": 1,
        "project_id": 2
      ],
      "for_creator": true,
      "message": [
        "project_id": 1,
        "message_thread_id": 2
      ],
      "survey": [
        "id": 3,
        "project_id": 4
      ],
      "activity": [
        "category": "update",
        "id": 5,
        "comment_id": 6,
        "project_id": 7,
        "project_photo": "photo",
        "update_id": 8,
        "user_photo": "photo2"
      ]
    ]).get()

    XCTAssertEqual(true, envelope.forCreator)
    XCTAssertEqual("Hi", envelope.aps.alert)
    XCTAssertEqual(1, envelope.message?.projectId)
    XCTAssertEqual(2, envelope.message?.messageThreadId)
    XCTAssertEqual(3, envelope.survey?.id)
    XCTAssertEqual(4, envelope.survey?.projectId)

    XCTAssertEqual(5, envelope.activity?.id)
    XCTAssertEqual(6, envelope.activity?.commentId)
    XCTAssertEqual(7, envelope.activity?.projectId)
    XCTAssertEqual(8, envelope.activity?.updateId)
    XCTAssertEqual("photo", envelope.activity?.projectPhoto)
    XCTAssertEqual("photo2", envelope.activity?.userPhoto)
  }
}
