import Foundation

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

extension Activity: Decodable {
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

extension Activity.Category: Decodable {}

extension Activity.MemberData: Decodable {
  private enum CodingKeys: String, CodingKey {
    case oldAmount = "old_amount"
    case oldRewardId = "old_reward_id"
    case newAmount = "new_amount"
    case newRewardId = "new_reward_id"
    case rewardId = "reward_id"
    case amount, backing
  }
}
