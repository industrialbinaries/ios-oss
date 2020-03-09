@testable import KsApi
import XCTest

final class CreatePledgeEnvelopeTests: XCTestCase {
  func testDecodingWithStringStatus() throws {
    let decoded = try CreatePledgeEnvelope
      .decodeJSON(["status": "200"])
      .get()
    XCTAssertEqual(200, decoded.status)
  }

  func testDecodingWithIntStatus() throws {
    let decoded = try CreatePledgeEnvelope
      .decodeJSON(["status": 200])
      .get()
    XCTAssertEqual(200, decoded.status)
  }

  func testDecodingWithMissingStatus() throws {
    let decoded = try CreatePledgeEnvelope
      .decodeJSON([:])
      .get()
    XCTAssertEqual(0, decoded.status)
  }

  func testDecodingWithBadStatusData() throws {
    let decoded = try CreatePledgeEnvelope
      .decodeJSON(["status": "bad data"])
      .get()
    XCTAssertEqual(0, decoded.status)
  }

  func testDecodingWithNewCheckoutUrl() throws {
    let decoded = try CreatePledgeEnvelope
      .decodeJSON([
        "status": "400",
        "data": [
          "checkout_url": "old",
          "new_checkout_url": "new"
        ]
      ])
      .get()
      XCTAssertEqual(400, decoded.status)
      XCTAssertEqual("old", decoded.checkoutUrl)
      XCTAssertEqual("new", decoded.newCheckoutUrl)
  }
}
