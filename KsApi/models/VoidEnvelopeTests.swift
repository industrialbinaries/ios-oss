@testable import KsApi
import XCTest

final class VoidEnvelopeTests: XCTestCase {
  func testJSONDecoding_WithEmtptyData() throws {
    let envelope = try VoidEnvelope.decodeJSON([:])
      .get()

    XCTAssertNotNil(envelope)
  }

  func testJSONDecoding_WithSomeData() throws {
    let envelope = try VoidEnvelope.decodeJSON(["body": "world"])
      .get()

    XCTAssertNotNil(envelope)
  }
}
