import Foundation

public struct ProjectStatsEnvelope {
  public let cumulativeStats: CumulativeStats
  public let fundingDistribution: [FundingDateStats]
  public let referralAggregateStats: ReferralAggregateStats
  public let referralDistribution: [ReferrerStats]
  public let rewardDistribution: [RewardStats]
  public let videoStats: VideoStats?

  public struct CumulativeStats {
    public let averagePledge: Int
    public let backersCount: Int
    public let goal: Int
    public let percentRaised: Double
    public let pledged: Int
  }

  public struct FundingDateStats {
    public let backersCount: Int
    public let cumulativePledged: Int
    public let cumulativeBackersCount: Int
    public let date: TimeInterval
    public let pledged: Int
  }

  public struct ReferralAggregateStats {
    public let custom: Double
    public let external: Double
    public let kickstarter: Double
  }

  public struct ReferrerStats {
    public let backersCount: Int
    public let code: String
    public let percentageOfDollars: Double
    public let pledged: Double
    public let referrerName: String
    public let referrerType: ReferrerType

    public enum ReferrerType {
      case custom
      case external
      case `internal`
      case unknown
    }
  }

  public struct RewardStats {
    public let backersCount: Int
    public let rewardId: Int
    public let minimum: Double?
    public let pledged: Int

    public static let zero = RewardStats(backersCount: 0, rewardId: 0, minimum: 0.00, pledged: 0)
  }

  public struct VideoStats {
    public let externalCompletions: Int
    public let externalStarts: Int
    public let internalCompletions: Int
    public let internalStarts: Int
  }
}

extension ProjectStatsEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case cumulativeStats = "cumulative"
    case fundingDistribution = "funding_distribution"
    case referralAggregateStats = "referral_aggregates"
    case referralDistribution = "referral_distribution"
    case rewardDistribution = "reward_distribution"
    case videoStats = "video_stats"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    cumulativeStats = try container.decode(.cumulativeStats)
    let fundingDistribution: [Failable<FundingDateStats>] = container.decodeArray(.fundingDistribution)
    self.fundingDistribution = fundingDistribution.compactMap { $0.value }
    referralAggregateStats = try container.decode(.referralAggregateStats)
    referralDistribution = container.decodeArray(.referralDistribution)
    rewardDistribution = container.decodeArray(.rewardDistribution)
    videoStats = container.decodeOptional(.videoStats)
  }
}

extension ProjectStatsEnvelope.CumulativeStats: Decodable {
  enum CodingKeys: String, CodingKey {
    case goal, pledged
    case averagePledge = "average_pledge"
    case backersCount = "backers_count"
    case percentRaised = "percent_raised"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let averagePledge: Double = try container.decode(.averagePledge)
    self.averagePledge = Int(averagePledge)
    backersCount = try container.decode(.backersCount)
    goal = stringToInt(container.decodeOptional(.goal)) ?? 0
    percentRaised = try container.decode(.percentRaised)
    pledged = stringToInt(container.decodeOptional(.pledged)) ?? 0
  }
}

extension ProjectStatsEnvelope.CumulativeStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.CumulativeStats, rhs: ProjectStatsEnvelope.CumulativeStats)
  -> Bool {
  return lhs.averagePledge == rhs.averagePledge
}

extension ProjectStatsEnvelope.FundingDateStats: Decodable {
  enum CodingKeys: String, CodingKey {
    case date, pledged
    case backersCount = "backers_count"
    case cumulativePledged = "cumulative_pledged"
    case cumulativeBackersCount = "cumulative_backers_count"
    case referrerType = "referrer_type"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    backersCount = container.decodeOptional(.backersCount) ?? 0
    cumulativePledged = stringToInt(container.decodeOptional(.cumulativePledged))
      ?? container.decodeOptional(.cumulativePledged)
      ?? 0
    cumulativeBackersCount = try container.decode(.cumulativeBackersCount)
    date = try container.decode(.date)
    pledged = stringToInt(container.decodeOptional(.pledged)) ?? 0
  }
}

extension ProjectStatsEnvelope.FundingDateStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.FundingDateStats, rhs: ProjectStatsEnvelope.FundingDateStats)
  -> Bool {
  return lhs.date == rhs.date
}

extension ProjectStatsEnvelope.ReferralAggregateStats: Decodable {
  enum CodingKeys: String, CodingKey {
    case custom, external
    case kickstarter = "internal"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    custom = try container.decode(.custom)
    kickstarter = stringToDouble(container.decodeOptional(.kickstarter))
      ?? container.decodeOptional(.kickstarter)
      ?? 0
    external = stringToDouble(container.decodeOptional(.external)) ?? 0
  }
}

extension ProjectStatsEnvelope.ReferralAggregateStats: Equatable {}
public func == (
  lhs: ProjectStatsEnvelope.ReferralAggregateStats,
  rhs: ProjectStatsEnvelope.ReferralAggregateStats
) -> Bool {
  return lhs.custom == rhs.custom &&
    lhs.external == rhs.external &&
    lhs.kickstarter == rhs.kickstarter
}

extension ProjectStatsEnvelope.ReferrerStats: Decodable {
  enum CodingKeys: String, CodingKey {
    case code, pledged
    case percentageOfDollars = "percentage_of_dollars"
    case backersCount = "backers_count"
    case referrerName = "referrer_name"
    case referrerType = "referrer_type"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    backersCount = try container.decode(.backersCount)
    code = try container.decode(.code)
    percentageOfDollars = stringToDouble(container.decodeOptional(.percentageOfDollars))
      ?? 0
    pledged = stringToDouble(container.decodeOptional(.pledged))
      ?? 0
    referrerName = try container.decode(.referrerName)
    referrerType = try container.decode(.referrerType)
  }
}

extension ProjectStatsEnvelope.ReferrerStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.ReferrerStats, rhs: ProjectStatsEnvelope.ReferrerStats) -> Bool {
  return lhs.code == rhs.code
}

extension ProjectStatsEnvelope.ReferrerStats.ReferrerType: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let value = try container.decode(String.self)

    switch value.lowercased() {
    case "custom": self = .custom
    case "external": self = .external
    case "kickstarter": self = .internal
    default:
      self = .unknown
    }
  }
}

extension ProjectStatsEnvelope.RewardStats: Decodable {
  enum CodingKeys: String, CodingKey {
    case minimum, pledged
    case backersCount = "backers_count"
    case rewardId = "reward_id"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    backersCount = try container.decode(.backersCount)
    rewardId = try container.decode(.rewardId)

    pledged = stringToInt(container.decodeOptional(.pledged))
      ?? 0
    minimum = stringToDouble(container.decodeOptional(.minimum))
      ?? container.decodeOptional(.minimum)
  }
}

extension ProjectStatsEnvelope.RewardStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.RewardStats, rhs: ProjectStatsEnvelope.RewardStats)
  -> Bool {
  return lhs.rewardId == rhs.rewardId
}

extension ProjectStatsEnvelope.VideoStats: Decodable {
  enum CodingKeys: String, CodingKey {
    case externalCompletions = "external_completions"
    case externalStarts = "external_starts"
    case internalCompletions = "internal_completions"
    case internalStarts = "internal_starts"
  }
}

extension ProjectStatsEnvelope.VideoStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.VideoStats, rhs: ProjectStatsEnvelope.VideoStats) -> Bool {
  return
    lhs.externalCompletions == rhs.externalCompletions &&
    lhs.externalStarts == rhs.externalStarts &&
    lhs.internalCompletions == rhs.internalCompletions &&
    lhs.internalStarts == rhs.internalStarts
}

private func stringToInt(_ string: String?) -> Int? {
  guard let string = string else { return nil }
  return
    Double(string).flatMap(Int.init)
    ?? Int(string)
    ?? 0
}

private func stringToDouble(_ string: String?) -> Double? {
  guard let string = string else { return nil }
  return
    Double(string)
    ?? 0
}
