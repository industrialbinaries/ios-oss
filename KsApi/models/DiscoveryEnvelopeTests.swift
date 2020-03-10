@testable import KsApi
import XCTest

final class DiscoveryEnvelopeTests: XCTestCase {

  func testJSONParsing_WithCompleteData() throws {
    let envelope = try DiscoveryEnvelope.decodeJSON([
      "projects": [],
      "urls": [
        "api":[
          "more_projects": "more"
        ]],
      "stats": [
        "count": 5
      ]
    ]).get()

    XCTAssertEqual([], envelope.projects)
    XCTAssertEqual("more", envelope.urls.api.moreProjects)
    XCTAssertEqual(5, envelope.stats.count)
  }
}
