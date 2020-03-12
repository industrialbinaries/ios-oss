import Foundation

public struct ShippingRule {
  public let cost: Double
  public let id: Int?
  public let location: Location
}

extension ShippingRule: Decodable {
  enum CodingKeys: String, CodingKey {
    case cost, id, location
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    location = try container.decode(.location)
    id = container.decodeOptional(.id)
    cost = stringToDouble(container.decodeOptional(.cost))
  }
}

extension ShippingRule: Equatable {}
public func == (lhs: ShippingRule, rhs: ShippingRule) -> Bool {
  // todo: change to compare id once that api is deployed
  return lhs.location == rhs.location
}

private func stringToDouble(_ string: String?) -> Double {
  guard let string = string else { return 0 }
  return Double(string).flatMap(Double.init) ?? 0
}
