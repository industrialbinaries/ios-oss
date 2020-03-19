@testable import KsApi
import XCTest

final class ShippingRulesEnvelopeTests: XCTestCase {
  func testJSONDecoding() throws {
    let json = [
      "shipping_rules": [
        [
          "cost": "1.234",
          "id": 1,
          "location":
            [
              "country": "country",
              "displayable_name": "displayable_name",
              "id": 1,
              "localized_name": "localized_name",
              "name": "name"
          ]
        ]
      ]
    ]

    let envelope = try ShippingRulesEnvelope.decodeJSON(json)
      .get()

    XCTAssertEqual(envelope.shippingRules.count, 1)
    let shippingRule = envelope.shippingRules.first
    XCTAssertEqual(shippingRule?.cost, 1.234)
    XCTAssertEqual(shippingRule?.id, 1)
    XCTAssertEqual(shippingRule?.location.id, 1)
    XCTAssertEqual(shippingRule?.location.country, "country")
    XCTAssertEqual(shippingRule?.location.displayableName, "displayable_name")
    XCTAssertEqual(shippingRule?.location.localizedName, "localized_name")
    XCTAssertEqual(shippingRule?.location.name, "name")
  }
}
