import Foundation

public struct UpdatePledgeEnvelope {
  public let newCheckoutUrl: String?
  public let status: Int
}

extension UpdatePledgeEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case newCheckoutUrl = "new_checkout_url"
    case status
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    newCheckoutUrl = container <&? .newCheckoutUrl
    status =
      container <&? .status
      ?? stringToIntOrZero(container <&? .status)
  }
}

private func stringToIntOrZero(_ string: String?) -> Int {
  guard let string = string else { return 0 }
  return
    Double(string).flatMap(Int.init)
    ?? Int(string)
    ?? 0
}
