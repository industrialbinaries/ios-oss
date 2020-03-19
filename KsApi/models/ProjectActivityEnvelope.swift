import Foundation

public struct ProjectActivityEnvelope: Decodable {
  public let activities: [Activity]
  public let urls: UrlsEnvelope

  public struct UrlsEnvelope: Decodable {
    public let api: ApiEnvelope

    public struct ApiEnvelope {
      public let moreActivities: String
    }
  }
}

extension ProjectActivityEnvelope.UrlsEnvelope.ApiEnvelope: Decodable {
  private enum CodingKeys: String, CodingKey {
    case moreActivities = "more_activities"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    moreActivities = container.decodeOptional(.moreActivities)
      ?? ""
  }
}
