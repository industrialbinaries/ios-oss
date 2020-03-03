@testable import KsApi
import XCTest

final class ExportDataEnvelopeTests: XCTestCase {
  func testJsonDecoding() {
    let json: [String: Any] = [
      "expires_at": "today",
      "state": "queued",
      "data_url": "url"
    ]

    let exportDateEnvelope = try! ExportDataEnvelope
      .decodeJSON(json)
      .get()

    XCTAssertEqual(exportDateEnvelope.expiresAt, "today")
    XCTAssertEqual(exportDateEnvelope.state, .queued)
    XCTAssertEqual(exportDateEnvelope.dataUrl, "url")
  }

  func testJsonDecoding_MissingData() {
    let json: [String: Any] = [
      "state": "completed"
    ]

    let exportDateEnvelope = try! ExportDataEnvelope
      .decodeJSON(json)
      .get()

    XCTAssertEqual(exportDateEnvelope.state, .completed)
    XCTAssertNil(exportDateEnvelope.dataUrl)
    XCTAssertNil(exportDateEnvelope.expiresAt)
  }
}
