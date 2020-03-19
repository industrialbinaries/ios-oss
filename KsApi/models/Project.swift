import Foundation
import Prelude

public struct Project {
  public var availableCardTypes: [String]?
  public var blurb: String
  public var category: Category
  public var country: Country
  public var creator: User
  public var memberData: MemberData
  public var dates: Dates
  public var id: Int
  public var location: Location
  public var name: String
  public var personalization: Personalization
  public var photo: Photo
  public var prelaunchActivated: Bool?
  public var rewards: [Reward]
  public var slug: String
  public var staffPick: Bool
  public var state: State
  public var stats: Stats
  public var urls: UrlsEnvelope
  public var video: Video?

  public struct Category {
    public var id: Int
    public var name: String
    public var parentId: Int?
    public var parentName: String?

    public var rootId: Int {
      return self.parentId ?? self.id
    }
  }

  public struct UrlsEnvelope: Decodable {
    public var web: WebEnvelope

    public struct WebEnvelope: Decodable {
      public var project: String
      public var updates: String?
    }
  }

  public struct Video: Decodable {
    public var id: Int
    public var high: String
    public var hls: String?
  }

  public enum State: String, CaseIterable, Decodable {
    case canceled
    case failed
    case live
    case purged
    case started
    case submitted
    case successful
    case suspended
  }

  public struct Stats {
    public var backersCount: Int
    public var commentsCount: Int?
    public var convertedPledgedAmount: Int?
    /// The currency code of the project ex. USD
    public var currency: String
    /// The currency code of the User's preferred currency ex. SEK
    public var currentCurrency: String?
    /// The currency conversion rate between the User's preferred currency
    /// and the Project's currency
    public var currentCurrencyRate: Float?
    public var goal: Int
    public var pledged: Int
    public var staticUsdRate: Float
    public var updatesCount: Int?

    /// Percent funded as measured from `0.0` to `1.0`. See `percentFunded` for a value from `0` to `100`.
    public var fundingProgress: Float {
      return self.goal == 0 ? 0.0 : Float(self.pledged) / Float(self.goal)
    }

    /// Percent funded as measured from `0` to `100`. See `fundingProgress` for a value between `0.0`
    /// and `1.0`.
    public var percentFunded: Int {
      return Int(floor(self.fundingProgress * 100.0))
    }

    /// Pledged amount converted to USD.
    public var pledgedUsd: Int {
      return Int(floor(Float(self.pledged) * self.staticUsdRate))
    }

    /// Goal amount converted to USD.
    public var goalUsd: Int {
      return Int(floor(Float(self.goal) * self.staticUsdRate))
    }

    /// Goal amount converted to current currency.
    public var goalCurrentCurrency: Int? {
      return self.currentCurrencyRate.map { Int(floor(Float(self.goal) * $0)) }
    }

    /// Country determined by current currency.
    public var currentCountry: Project.Country? {
      guard let currentCurrency = self.currentCurrency else {
        return nil
      }

      return Project.Country(currencyCode: currentCurrency)
    }

    /// Omit US currency code
    public var omitUSCurrencyCode: Bool {
      let currentCurrency = self.currentCurrency ?? Project.Country.us.currencyCode

      return currentCurrency == Project.Country.us.currencyCode
    }

    /// Project pledge & goal values need conversion
    public var needsConversion: Bool {
      let currentCurrency = self.currentCurrency ?? Project.Country.us.currencyCode

      return self.currency != currentCurrency
    }
  }

  public struct MemberData {
    public var lastUpdatePublishedAt: TimeInterval?
    public var permissions: [Permission]
    public var unreadMessagesCount: Int?
    public var unseenActivityCount: Int?

    public enum Permission: String, Decodable {
      case editProject = "edit_project"
      case editFaq = "edit_faq"
      case post
      case comment
      case viewPledges = "view_pledges"
      case fulfillment
      case unknown
    }
  }

  public struct Dates {
    public var deadline: TimeInterval
    public var featuredAt: TimeInterval?
    public var launchedAt: TimeInterval
    public var stateChangedAt: TimeInterval

    /**
     Returns project duration in Days
     */
    public func duration(using calendar: Calendar = .current) -> Int? {
      let deadlineDate = Date(timeIntervalSince1970: self.deadline)
      let launchedAtDate = Date(timeIntervalSince1970: self.launchedAt)

      return calendar.dateComponents([.day], from: launchedAtDate, to: deadlineDate).day
    }

    public func hoursRemaining(from date: Date = Date(), using calendar: Calendar = .current) -> Int? {
      let deadlineDate = Date(timeIntervalSince1970: self.deadline)

      guard let hoursRemaining = calendar.dateComponents([.hour], from: date, to: deadlineDate).hour else {
        return nil
      }

      return max(0, hoursRemaining)
    }
  }

  public struct Personalization {
    public var backing: Backing?
    public var friends: [User]?
    public var isBacking: Bool?
    public var isStarred: Bool?
  }

  public struct Photo {
    public var full: String
    public var med: String
    public var size1024x768: String? // TODO: Maybe needs a better name? It can contain the values for both 1024x768 and 1024x576.
    public var small: String
  }

  public func endsIn48Hours(today: Date = Date()) -> Bool {
    let twoDays: TimeInterval = 60.0 * 60.0 * 48.0
    return self.dates.deadline - today.timeIntervalSince1970 <= twoDays
  }

  public func isFeaturedToday(today: Date = Date(), calendar: Calendar = .current) -> Bool {
    guard let featuredAt = self.dates.featuredAt else { return false }
    return self.isDateToday(date: featuredAt, today: today, calendar: calendar)
  }

  private func isDateToday(date: TimeInterval, today: Date, calendar: Calendar) -> Bool {
    let startOfToday = calendar.startOfDay(for: today)
    return abs(startOfToday.timeIntervalSince1970 - date) < 60.0 * 60.0 * 24.0
  }
}

extension Project: Equatable {}
public func == (lhs: Project, rhs: Project) -> Bool {
  return lhs.id == rhs.id
}

extension Project: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "Project(id: \(self.id), name: \"\(self.name)\")"
  }
}

extension Project: GraphIDBridging {
  public static var modelName: String {
    return "Project"
  }
}

// MARK: Decodable

extension Project: Decodable {
  private enum CodingKeys: String, CodingKey {
    case blurb, id, category, creator, location, name, photo, rewards, slug, state, urls, video
    case availableCardTypes = "available_card_types"
    case prelaunchActivated = "prelaunch_activated"
    case staffPick = "staff_pick"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    blurb = try container.decode(.blurb)
    id = try container.decode(.id)
    category = try container.decode(.category)
    name = try container.decode(.name)
    creator = try container.decode(.creator)
    location = container.decodeOptional(.location)
      ?? .none
    photo = try container.decode(.photo)
    rewards = container.decodeArray(.rewards)
    slug = try container.decode(.slug)
    state = try container.decode(.state)
    urls = try container.decode(.urls)
    video = try container.decode(.video)
    availableCardTypes = container.decodeOptional(.availableCardTypes)
    prelaunchActivated = container.decodeOptional(.prelaunchActivated)
    staffPick = try container.decode(.staffPick)
    stats = try .init(from: decoder)
    personalization = try .init(from: decoder)
    country = try .init(from: decoder)
    memberData = try .init(from: decoder)
    dates = try .init(from: decoder)
  }
}


extension Project.Category: Decodable {
  private enum CodingKeys: String, CodingKey {
    case id, name
    case parentId = "parent_id"
    case parentName = "parent_name"
  }
}

extension Project.Stats: Decodable {
  private enum CodingKeys: String, CodingKey {
    case currency, goal, pledged
    case backersCount = "backers_count"
    case commentsCount = "comments_count"
    case convertedPledgedAmount = "converted_pledged_amount"
    case currentCurrency = "current_currency"
    case currentCurrencyRate = "fx_rate"
    case staticUsdRate = "static_usd_rate"
    case updatesCount = "updates_count"
  }
}

extension Project.Personalization: Decodable {
  private enum CodingKeys: String, CodingKey {
    case backing, friends
    case isBacking = "is_backing"
    case isStarred = "is_starred"
  }
}

extension Project.MemberData: Decodable {
  private enum CodingKeys: String, CodingKey {
    case permissions
    case lastUpdatePublishedAt = "last_update_published_at"
    case unreadMessagesCount = "unread_messages_count"
    case unseenActivityCount = "unseen_activity_count"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    lastUpdatePublishedAt = container.decodeOptional(.lastUpdatePublishedAt)
    unreadMessagesCount = container.decodeOptional(.unreadMessagesCount)
    unseenActivityCount = container.decodeOptional(.unseenActivityCount)
    let permissions: [Failable<Permission>] = container.decodeArray(.permissions)
    self.permissions = permissions
      .compactMap { $0.value }
      .filter { $0 != .unknown }
  }
}

extension Project.Dates: Decodable {
  private enum CodingKeys: String, CodingKey {
    case deadline
    case featuredAt = "featured_at"
    case launchedAt = "launched_at"
    case stateChangedAt = "state_changed_at"
  }
}

extension Project.Photo: Decodable {
  private enum CodingKeys: String, CodingKey {
    case full, med, small
    case url1024x768 = "1024x768"
    case url1024x576 = "1024x576"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    full = try container.decode(.full)
    med = try container.decode(.med)
    small = try container.decode(.small)
    size1024x768 = container.decodeOptional(.url1024x768)
      ?? container.decodeOptional(.url1024x576)
  }
}
