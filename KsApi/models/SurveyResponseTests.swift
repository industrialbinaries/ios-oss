@testable import KsApi
import XCTest

internal final class SurveyResponseTests: XCTestCase {
  func testJSONDecoding() throws {
    let decoded = try SurveyResponse.decodeJSON([
      "id": 1,
      "urls": [
        "web": [
          "survey": "http://"
        ]
      ]
      ]).get()

    XCTAssertEqual(1, decoded.id)
    XCTAssertEqual("http://", decoded.urls.web.survey)
  }
}
