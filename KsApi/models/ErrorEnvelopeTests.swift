@testable import KsApi
import XCTest

class ErrorEnvelopeTests: XCTestCase {
  func testJsonDecodingWithFullData() throws {
    let env = try ErrorEnvelope.decodeJSON([
      "error_messages": ["hello"],
      "ksr_code": "access_token_invalid",
      "http_code": 401,
      "exception": [
        "backtrace": ["hello"],
        "message": "hello"
      ]
      ]).get()
    XCTAssertNotNil(env)
  }

  func testJsonDecodingWithBadKsrCode() throws {
    let env = try ErrorEnvelope.decodeJSON([
      "error_messages": ["hello"],
      "ksr_code": "doesnt_exist",
      "http_code": 401,
      "exception": [
        "backtrace": ["hello"],
        "message": "hello"
      ]
      ]).get()
    XCTAssertEqual(ErrorEnvelope.KsrCode.UnknownCode, env.ksrCode)
  }

  func testJsonDecodingWithNonStandardError() throws {
    let env = try ErrorEnvelope.decodeJSON([
      "status": 406,
      "data": [
        "errors": [
          "amount": [
            "Bad amount"
          ]
        ]
      ]
      ]).get()
    XCTAssertEqual(ErrorEnvelope.KsrCode.UnknownCode, env.ksrCode)
    // swiftlint:disable:next force_unwrapping
    XCTAssertEqual(["Bad amount"], env.errorMessages)
    XCTAssertEqual(406, env.httpCode)
  }
}
