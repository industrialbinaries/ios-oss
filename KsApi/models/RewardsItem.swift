import Foundation

public struct RewardsItem {
  public let id: Int
  public let item: Item
  public let quantity: Int
  public let rewardId: Int
}

extension RewardsItem: Decodable {
  private enum CodingKeys: String, CodingKey {
    case id, item, quantity
    case rewardId = "reward_id"
  }
}
