@testable import KsApi
import Prelude
import XCTest

internal final class UpdateTests: XCTestCase {
  func testEquatable() {
    XCTAssertEqual(Update.template, Update.template)
    XCTAssertNotEqual(Update.template, Update.template |> Update.lens.id %~ { $0 + 1 })
  }

  func testJSONDecoding_WithBadData() {
    let update = Update.decodeJSON([
      "body": "world"
    ])

    guard case let .failure(error) = update else {
      XCTFail("Missing error value.")
      return
    }
    XCTAssertNotNil(error)
  }

  func testJSONDecoding_WithGoodData() throws {
    let update = try Update.decodeJSON([
      "body": "world",
      "id": 1,
      "public": true,
      "project_id": 2,
      "sequence": 3,
      "title": "hello",
      "visible": true,
      "urls": [
        "web": [
          "update": "https://www.kickstarter.com/projects/udoo/udoo-x86/posts/1571540"
        ]
      ]
      ]).get()

    XCTAssertEqual(1, update.id)
  }

  func testJSONDecoding_WithNestedGoodData() throws {
    let update = try Update.decodeJSON([
      "body": "world",
      "id": 1,
      "public": true,
      "project_id": 2,
      "sequence": 3,
      "title": "hello",
      "user": [
        "id": 2,
        "name": "User",
        "avatar": [
          "medium": "img.jpg",
          "small": "img.jpg",
          "large": "img.jpg"
        ]
      ],
      "visible": true,
      "urls": [
        "web": [
          "update": "https://www.kickstarter.com/projects/udoo/udoo-x86/posts/1571540"
        ]
      ]
      ]).get()

    XCTAssertEqual(1, update.id)
    XCTAssertEqual(2, update.user?.id)
    XCTAssertEqual(
      "https://www.kickstarter.com/projects/udoo/udoo-x86/posts/1571540",
      update.urls.web.update
    )
  }
}
