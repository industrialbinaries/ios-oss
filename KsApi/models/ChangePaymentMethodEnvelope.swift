import Argo
import Curry
import Runes

public struct ChangePaymentMethodEnvelope {
  public let newCheckoutUrl: String?
  public let status: Int
}

extension ChangePaymentMethodEnvelope: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<ChangePaymentMethodEnvelope> {
    return curry(ChangePaymentMethodEnvelope.init)
      <^> json <|? ["data", "new_checkout_url"]
      <*> ((json <| "status" >>- stringToIntOrZero) <|> (json <| "status"))
  }
}

private func stringToIntOrZero(_ string: String) -> Decoded<Int> {
  return
    Double(string).flatMap(Int.init).map(Decoded.success)
    ?? Int(string).map(Decoded.success)
    ?? .success(0)
}

extension ChangePaymentMethodEnvelope: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
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

private struct NewCheckoutURLData: Swift.Decodable {
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
