import Foundation

public struct CreatePledgeEnvelope {
  public let checkoutUrl: String?
  public let newCheckoutUrl: String?
  public let status: Int
}

extension CreatePledgeEnvelope: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case data, status
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let data: CheckoutURLData? = container.decodeOptional(.data)
    checkoutUrl = data?.checkoutUrl
    newCheckoutUrl = data?.newCheckoutUrl
    status =
      container.decodeOptional(.status)
      ?? stringToIntOrZero(container.decodeOptional(.status))
  }
}

private struct CheckoutURLData: Decodable {
  private enum CodingKeys: String, CodingKey {
    case checkoutUrl = "checkout_url"
    case newCheckoutUrl = "new_checkout_url"

  }

  let checkoutUrl: String?
  let newCheckoutUrl: String?
}

private func stringToIntOrZero(_ string: String?) -> Int {
  guard let string = string else { return 0 }
  return
    Double(string).flatMap(Int.init)
    ?? Int(string)
    ?? 0
}
