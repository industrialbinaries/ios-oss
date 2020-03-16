import Foundation

public struct Message {
  public let body: String
  public let createdAt: TimeInterval
  public let id: Int
  public let recipient: User
  public let sender: User
}

extension Message: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case id, body, recipient, sender
    case createdAt = "created_at"
  }
}
