@testable import KsApi
import XCTest

internal final class CommentsEnvelopeTests: XCTestCase {

  func testJSONDecoding() throws {
    let envelope = try CommentsEnvelope.decodeJSON([
      "comments": [
        [
          "author":
            [
              "id": 1,
              "name": "Nino Teixeira",
              "avatar": [
                "thumb": "https://ksr-qa-ugc.imgix.net/thumb.jpg",
                "small": "https://ksr-qa-ugc.imgix.net/small.jpg",
                "medium": "https://ksr-qa-ugc.imgix.net/medium.jpg"
              ],
              "urls": [
                "web": [
                  "user": "https://staging.kickstarter.com/profile/382491714"
                ],
                "api": [
                  "user": "https://api-staging.kickstarter.com/v1/users/382491714"
                ]
              ]
          ],
          "body": "text",
          "created_at": 10,
          "deleted_at": 20,
          "id": 2
        ]
      ],
      "urls": [
        "api": [
          "more_comments": "test"
        ]
      ]
    ]).get()

    XCTAssertEqual("test", envelope.urls.api.moreComments)
    XCTAssertEqual(1, envelope.comments.count)
    XCTAssertEqual(2, envelope.comments.first?.id)
  }

  func testJSONDecoding_withoutActivities() throws {
    let envelope = try CommentsEnvelope.decodeJSON([
      "comments": [],
      "urls": [
        "api": [:]
      ]
    ]).get()

    XCTAssertEqual("", envelope.urls.api.moreComments)
    XCTAssertEqual([], envelope.comments)
  }
}
