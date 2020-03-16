import Foundation

public struct UpdatePledgeEnvelope {
  public let newCheckoutUrl: String?
  public let status: Int
}

extension UpdatePledgeEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case data, status
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let data: NewCheckoutURLData? = container.decodeOptional(.data)
    newCheckoutUrl = data?.newCheckoutUrl
    status =
      container.decodeOptional(.status)
      ?? stringToIntOrZero(container.decodeOptional(.status))
  }
}

private struct NewCheckoutURLData: Decodable {
  private enum CodingKeys: String, CodingKey {
    case newCheckoutUrl = "new_checkout_url"
  }

  let newCheckoutUrl: String?
}

private func stringToIntOrZero(_ string: String?) -> Int {
  guard let string = string else { return 0 }
  return
    Double(string).flatMap(Int.init)
    ?? Int(string)
    ?? 0
}
