@testable import KsApi
import XCTest

final class UpdatePledgeEnvelopeTests: XCTestCase {
  func testDecodingWithStringStatus() throws {
    let decoded = try UpdatePledgeEnvelope
      .decodeJSON(["status": "200"])
      .get()
    XCTAssertEqual(200, decoded.status)
  }

  func testDecodingWithIntStatus() throws {
    let decoded = try UpdatePledgeEnvelope
      .decodeJSON(["status": 200])
      .get()
    XCTAssertEqual(200, decoded.status)
  }

  func testDecodingWithMissingStatus() throws {
    let decoded = try UpdatePledgeEnvelope
      .decodeJSON([:])
      .get()
    XCTAssertEqual(0, decoded.status)
  }

  func testDecodingWithBadStatusData() throws {
    let decoded = try UpdatePledgeEnvelope
      .decodeJSON(["status": "bad data"])
      .get()
    XCTAssertEqual(0, decoded.status)
  }

  func testDecodingWithNewCheckoutUrl() throws {
    let decoded = try UpdatePledgeEnvelope
      .decodeJSON(["status": "400", "new_checkout_url": "new" ])
      .get()
      XCTAssertEqual(400, decoded.status)
      XCTAssertEqual("new", decoded.newCheckoutUrl)
  }
}
