import Foundation

public struct CommentsEnvelope: Decodable {
  public let comments: [Comment]
  public let urls: UrlsEnvelope

  public struct UrlsEnvelope: Decodable {
    public let api: ApiEnvelope

    public struct ApiEnvelope: Decodable {
      public let moreComments: String
    }
  }
}

extension CommentsEnvelope.UrlsEnvelope.ApiEnvelope {
  enum CodingKeys: String, CodingKey {
    case moreComments = "more_comments"
  }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      moreComments = container.decodeOptional(.moreComments) ?? ""
    }
}
