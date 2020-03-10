import Argo
import Curry
import Runes

public struct Backing {
  public let amount: Double
  public let backer: User?
  public let backerId: Int
  public let backerCompleted: Bool?
  public let cancelable: Bool
  public let id: Int
  public let locationId: Int?
  public let locationName: String?
  public let paymentSource: PaymentSource?
  public let pledgedAt: TimeInterval
  public let projectCountry: String
  public let projectId: Int
  public let reward: Reward?
  public let rewardId: Int?
  public let sequence: Int
  public let shippingAmount: Int?
  public let status: Status

  public struct PaymentSource {
    public var expirationDate: String?
    public var id: String?
    public var lastFour: String?
    public var paymentType: PaymentType
    public var state: String
    public var type: GraphUserCreditCard.CreditCardType?

    public var imageName: String {
      switch self.type {
      case nil, .some(.generic):
        return "icon--generic"
      case let .some(type):
        return "icon--\(type.rawValue.lowercased())"
      }
    }
  }

  public enum PaymentType: String {
    case applePay = "APPLE_PAY"
    case creditCard = "CREDIT_CARD"
    case googlePay = "ANDROID_PAY"

    public var accessibilityLabel: String? {
      switch self {
      case .applePay:
        return "Apple Pay"
      case .googlePay:
        return "Google Pay"
      case .creditCard:
        return nil
      }
    }
  }

  public enum Status: String, CaseIterable {
    case canceled
    case collected
    case dropped
    case errored
    case pledged
    case preauth
  }
}

extension Backing: Equatable {}

public func == (lhs: Backing, rhs: Backing) -> Bool {
  return lhs.id == rhs.id
}

extension Backing: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<Backing> {
    let tmp1 = curry(Backing.init)
      <^> json <| "amount"
      <*> json <|? "backer"
      <*> json <| "backer_id"
      <*> json <|? "backer_completed_at"
      <*> json <| "cancelable"
      <*> json <| "id"
    let tmp2 = tmp1
      <*> json <|? "location_id"
      <*> json <|? "location_name"
      <*> (json <|? "payment_source" >>- tryDecodePaymentSource)
      <*> json <| "pledged_at"
      <*> json <| "project_country"
      <*> json <| "project_id"
    return tmp2
      <*> json <|? "reward"
      <*> json <|? "reward_id"
      <*> json <| "sequence"
      <*> json <|? "shipping_amount"
      <*> json <| "status"
  }
}

#warning("Function tryDecodePaymentSource(_:) should be deleted once the data is being returned normally.")
/*
 Since staging is not returning all the values for Payment Source, the Backing deserialization is failing
 on that environment. This is a workaround to allow us to test on Staging and should be deleted once the
 data is being returned normally.
 */
private func tryDecodePaymentSource(_ json: JSON?) -> Decoded<Backing.PaymentSource?> {
  guard let json = json else {
    return .success(nil)
  }

  let value = Backing.PaymentSource.decode(json)

  switch value {
  case let .success(value):
    return .success(value)
  case .failure:
    return .success(nil)
  }
}

extension Backing: EncodableType {
  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["backer_completed_at"] = self.backerCompleted
    return result
  }
}

extension Backing.PaymentSource: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<Backing.PaymentSource?> {
    return curry(Backing.PaymentSource.init)
      <^> json <|? "expiration_date"
      <*> json <|? "id"
      <*> json <|? "last_four"
      <*> json <| "payment_type"
      <*> json <| "state"
      <*> json <|? "type"
  }
}

extension Backing.Status: Argo.Decodable {}

extension Backing.PaymentType: Argo.Decodable {}

extension Backing.PaymentSource: Equatable {}
public func == (lhs: Backing.PaymentSource, rhs: Backing.PaymentSource) -> Bool {
  return lhs.id == rhs.id
}

extension Backing {
  /// Returns the pledge amount subtracting the shipping amount
  public var pledgeAmount: Double {
    let shippingAmount = Double(self.shippingAmount ?? 0)
    let pledgeAmount = Decimal(amount) - Decimal(shippingAmount)

    return (pledgeAmount as NSDecimalNumber).doubleValue
  }
}

extension Backing: GraphIDBridging {
  public static var modelName: String {
    return "Backing"
  }
}

// MARK: - Swift decodable

extension Backing: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case amount, backer, cancelable, id, reward, sequence, status
    case backerId = "backer_id"
    case backerCompleted = "backer_completed_at"
    case locationId = "location_id"
    case locationName = "location_name"
    case paymentSource = "payment_source"
    case pledgedAt = "pledged_at"
    case projectCountry = "project_country"
    case projectId = "project_id"
    case rewardId = "reward_id"
    case shippingAmount = "shipping_amount"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(.id)
    amount = try container.decode(.amount)
    backer = container.decodeOptional(.backer)
    cancelable = try container.decode(.cancelable)
    reward = container.decodeOptional(.reward)
    sequence = try container.decode(.sequence)
    status = try container.decode(.status)
    backerId = try container.decode(.backerId)
    backerCompleted = container.decodeOptional(.backerCompleted)
    locationId = container.decodeOptional(.locationId)
    locationName = container.decodeOptional(.locationName)
    paymentSource = container.decodeOptional(.paymentSource)
    pledgedAt = try container.decode(.pledgedAt)
    projectCountry = try container.decode(.projectCountry)
    projectId = try container.decode(.projectId)
    rewardId = container.decodeOptional(.rewardId)
    shippingAmount = container.decodeOptional(.shippingAmount)
  }
}

extension Backing.PaymentSource: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case id, state, type
    case expirationDate = "expiration_date"
    case lastFour = "last_four"
    case paymentType = "payment_type"
  }
}

extension Backing.Status: Swift.Decodable {}

extension Backing.PaymentType: Swift.Decodable {}
