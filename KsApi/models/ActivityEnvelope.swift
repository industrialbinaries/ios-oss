import Argo
import Curry
import Runes

public struct ActivityEnvelope: Swift.Decodable {
  public let activities: [Activity]
  public let urls: UrlsEnvelope

  public struct UrlsEnvelope: Swift.Decodable {
    public let api: ApiEnvelope

    public struct ApiEnvelope {
      public let moreActivities: String
    }
  }
}

extension ActivityEnvelope: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<ActivityEnvelope> {
    return curry(ActivityEnvelope.init)
      <^> json <|| "activities"
      <*> json <| "urls"
  }
}

extension ActivityEnvelope.UrlsEnvelope: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<ActivityEnvelope.UrlsEnvelope> {
    return curry(ActivityEnvelope.UrlsEnvelope.init)
      <^> json <| "api"
  }
}

extension ActivityEnvelope.UrlsEnvelope.ApiEnvelope: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<ActivityEnvelope.UrlsEnvelope.ApiEnvelope> {
    return curry(ActivityEnvelope.UrlsEnvelope.ApiEnvelope.init)
      <^> (json <| "more_activities" <|> .success(""))
  }
}

extension ActivityEnvelope.UrlsEnvelope.ApiEnvelope: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case moreActivities = "more_activities"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    moreActivities = container.decodeOptional(.moreActivities)
      ?? ""
  }
}
