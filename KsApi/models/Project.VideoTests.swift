@testable import KsApi
import XCTest

final class ProjectVideoTests: XCTestCase {
  func testJsonParsing_WithFullData() throws {
    let video = try Project.Video.decodeJSON([
      "id": 1,
      "high": "kickstarter.com/video.mp4"
      ]).get()

    XCTAssertEqual(video.id, 1)
    XCTAssertEqual(video.high, "kickstarter.com/video.mp4")
  }
}
