import Foundation

public struct Update {
  public let body: String?
  public let commentsCount: Int?
  public let hasLiked: Bool?
  public let id: Int
  public let isPublic: Bool
  public let likesCount: Int?
  public let projectId: Int
  public let publishedAt: TimeInterval?
  public let sequence: Int
  public let title: String
  public let urls: UrlsEnvelope
  public let user: User?
  public let visible: Bool?

  public struct UrlsEnvelope: Decodable {
    public let web: WebEnvelope

    public struct WebEnvelope: Decodable {
      public let update: String
    }
  }
}

extension Update: Equatable {}

public func == (lhs: Update, rhs: Update) -> Bool {
  return lhs.id == rhs.id
}

extension Update: Decodable {
  private enum CodingKeys: String, CodingKey {
    case body, id, sequence, title, urls, user, visible
    case commentsCount = "comments_count"
    case hasLiked = "has_liked"
    case isPublic = "public"
    case likesCount = "likes_count"
    case projectId = "project_id"
    case publishedAt = "published_at"
  }
}
