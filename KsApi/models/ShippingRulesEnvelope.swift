import Foundation

public struct ShippingRulesEnvelope {
  public let shippingRules: [ShippingRule]
}

extension ShippingRulesEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case shippingRules = "shipping_rules"
  }
}
