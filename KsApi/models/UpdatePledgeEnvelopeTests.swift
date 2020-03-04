@testable import KsApi
import XCTest

final class UpdatePledgeEnvelopeTests: XCTestCase {
  func testDecodingWithStringStatus() {
    let decoded = UpdatePledgeEnvelope.decodeJSONDictionary(["status": "200"])
    XCTAssertNil(decoded.error)
    XCTAssertEqual(200, decoded.value?.status)
  }

  func testDecodingWithIntStatus() {
    let decoded = UpdatePledgeEnvelope.decodeJSONDictionary(["status": 200])
    XCTAssertNil(decoded.error)
    XCTAssertEqual(200, decoded.value?.status)
  }

  func testDecodingWithMissingStatus() {
    let decoded = UpdatePledgeEnvelope.decodeJSONDictionary([:])
    XCTAssertNotNil(decoded.error)
  }

  func testDecodingWithNewCheckoutUrl() throws {
    let decoded = UpdatePledgeEnvelope
      .decodeJSONDictionary(["status": "400", "new_checkout_url": "new" ])
      XCTAssertNil(decoded.error)
      XCTAssertEqual(400, decoded.status)
      XCTAssertEqual("new", decoded.newCheckoutUrl)
  }
}
