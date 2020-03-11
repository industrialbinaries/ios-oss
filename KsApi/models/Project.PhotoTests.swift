@testable import KsApi
import XCTest

final class ProjectPhotoTests: XCTestCase {
  func testJSONParsing_WithPartialData() {
    let photo = Project.Photo.decodeJSON([
      "full": "http://www.kickstarter.com/full.jpg",
      "med": "http://www.kickstarter.com/med.jpg"
    ])

    guard case let .failure(error) = photo else {
      XCTFail("Missing error value.")
      return
    }
    XCTAssertNotNil(error)
  }

  func testJSONParsing_WithMissing1024() throws {
    let photo = try Project.Photo.decodeJSON([
      "full": "http://www.kickstarter.com/full.jpg",
      "med": "http://www.kickstarter.com/med.jpg",
      "small": "http://www.kickstarter.com/small.jpg"
      ]).get()

    XCTAssertEqual(photo.full, "http://www.kickstarter.com/full.jpg")
    XCTAssertEqual(photo.med, "http://www.kickstarter.com/med.jpg")
    XCTAssertEqual(photo.small, "http://www.kickstarter.com/small.jpg")
    XCTAssertNil(photo.size1024x768)
  }

  func testJSONParsing_WithFullData() throws {
    let photo = try Project.Photo.decodeJSON([
      "full": "http://www.kickstarter.com/full.jpg",
      "med": "http://www.kickstarter.com/med.jpg",
      "small": "http://www.kickstarter.com/small.jpg",
      "1024x768": "http://www.kickstarter.com/1024x768.jpg"
    ]).get()

    XCTAssertEqual(photo.full, "http://www.kickstarter.com/full.jpg")
    XCTAssertEqual(photo.med, "http://www.kickstarter.com/med.jpg")
    XCTAssertEqual(photo.small, "http://www.kickstarter.com/small.jpg")
    XCTAssertEqual(photo.size1024x768, "http://www.kickstarter.com/1024x768.jpg")
  }
}
