@testable import KsApi
import XCTest

final class AuthorTests: XCTestCase {
  func testJSONParsing_WithCompleteData() throws {
    let author = try Author.decodeJSON([
      "id": 382_491_714,
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
      ]).get()

    XCTAssertEqual(382_491_714, author.id)
    XCTAssertEqual("Nino Teixeira", author.name)
    XCTAssertEqual("https://ksr-qa-ugc.imgix.net/small.jpg", author.avatar.small)
    XCTAssertEqual("https://staging.kickstarter.com/profile/382491714", author.urls.web)
  }

  func testJSONParsing_WithIncompleteData() {
    let author = Author.decodeJSON([
      "id": 1,
      "name": "Blob",
      "avatar": [
        "medium": "http://www.kickstarter.com/medium.jpg",
        "small": "http://www.kickstarter.com/small.jpg"
      ]
    ])

    guard case let .failure(error) = author else {
      XCTFail("Unexpected state")
      return
    }
    XCTAssertNotNil(error)
  }

  func testJSONParsing_SwiftDecoder() {
    let jsonString = """
    {
      "id": 382491714,
      "name": "Nino Teixeira",
      "avatar": {
        "thumb": "https://ksr-qa-ugc.imgix.net/thumb_avatar.png",
        "small": "https://ksr-qa-ugc.imgix.net/small_avatar.png",
        "medium": "https://ksr-qa-ugc.imgix.net/medium_avatar.png"
        },
      "urls": {
        "web": {
          "user": "https://staging.kickstarter.com/profile/382491714"
        },
        "api": {
          "user": "https://api-staging.kickstarter.com/v1/users/382491714"
        }
      }
    }
    """

    // swiftlint:disable:next force_unwrapping
    let data = jsonString.data(using: .utf8)!
    let author = try? JSONDecoder().decode(Author.self, from: data)

    XCTAssertEqual(author?.id, 382_491_714)
    XCTAssertEqual(author?.name, "Nino Teixeira")
  }
}
