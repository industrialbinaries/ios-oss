import Foundation

public struct Comment {
  public let author: Author
  public let body: String
  public let createdAt: TimeInterval
  public let deletedAt: TimeInterval?
  public let id: Int
}

extension Comment: Decodable {
  enum CodingKeys: String, CodingKey {
    case author
    case body
    case createdAt = "created_at"
    case deletedAt = "deleted_at"
    case id
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.author = try values.decode(Author.self, forKey: .author)
    self.body = try values.decode(String.self, forKey: .body)
    self.createdAt = try values.decode(TimeInterval.self, forKey: .createdAt)
    let deletedAt = try values.decode(TimeInterval?.self, forKey: .deletedAt)
    self.deletedAt = decodePositiveTimeInterval(deletedAt)
    self.id = try values.decode(Int.self, forKey: .id)
  }
}

extension Comment: Equatable {}

public func == (lhs: Comment, rhs: Comment) -> Bool {
  return lhs.id == rhs.id
}

// Decode a time interval so that non-positive values are coalesced to `nil`. We do this because the API
// sends back `0` when the comment hasn't been deleted, and we'd rather handle that value as `nil`.
private func decodePositiveTimeInterval(_ interval: TimeInterval?) -> TimeInterval? {
  if let interval = interval, interval > 0.0 {
    return interval
  }
  return nil
}
