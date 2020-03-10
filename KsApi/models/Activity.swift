import Argo
import Curry
import Foundation
import Runes

public struct Activity {
  public let category: Activity.Category
  public let comment: Comment?
  public let createdAt: TimeInterval
  public let id: Int
  public let memberData: MemberData
  public let project: Project?
  public let update: Update?
  public let user: User?

  public enum Category: String {
    case backing
    case backingAmount = "backing-amount"
    case backingCanceled = "backing-canceled"
    case backingDropped = "backing-dropped"
    case backingReward = "backing-reward"
    case cancellation
    case commentPost = "comment-post"
    case commentProject = "comment-project"
    case failure
    case follow
    case funding
    case launch
    case success
    case suspension
    case update
    case watch
    case unknown
  }

  public struct MemberData {
    public let amount: Int?
    public let backing: Backing?
    public let oldAmount: Int?
    public let oldRewardId: Int?
    public let newAmount: Int?
    public let newRewardId: Int?
    public let rewardId: Int?
  }
}

extension Activity: Equatable {}

public func == (lhs: Activity, rhs: Activity) -> Bool {
  return lhs.id == rhs.id
}

extension Activity: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<Activity> {
    let tmp = curry(Activity.init)
      <^> json <| "category"
      <*> json <|? "comment"
      <*> json <| "created_at"
      <*> json <| "id"
    return tmp
      <*> Activity.MemberData.decode(json)
      <*> json <|? "project"
      <*> json <|? "update"
      <*> json <|? "user"
  }
}

extension Activity.Category: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<Activity.Category> {
    switch json {
    case let .string(category):
      return .success(Activity.Category(rawValue: category) ?? .unknown)
    default:
      return .failure(.typeMismatch(expected: "String", actual: json.description))
    }
  }
}

extension Activity.MemberData: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<Activity.MemberData> {
    let tmp = curry(Activity.MemberData.init)
      <^> json <|? "amount"
      <*> json <|? "backing"
      <*> json <|? "old_amount"
      <*> json <|? "old_reward_id"
    return tmp
      <*> json <|? "new_amount"
      <*> json <|? "new_reward_id"
      <*> json <|? "reward_id"
  }
}

// MARK: - Swift decodable

extension Activity: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case category, comment, id, project, update, user
    case createdAt = "created_at"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    category = container.decodeOptional(.category)
      ?? .unknown
    comment = container.decodeOptional(.comment)
    createdAt = try container.decode(.createdAt)
    id = try container.decode(.id)
    project = container.decodeOptional(.project)
    update = container.decodeOptional(.update)
    user = container.decodeOptional(.user)

    memberData = try .init(from: decoder)
  }
}

extension Activity.Category: Swift.Decodable {}

extension Activity.MemberData: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case oldAmount = "old_amount"
    case oldRewardId = "old_reward_id"
    case newAmount = "new_amount"
    case newRewardId = "new_reward_id"
    case rewardId = "reward_id"
    case amount, backing
  }
}
