import Argo
import Curry
import Foundation
import Runes

public struct Message {
  public let body: String
  public let createdAt: TimeInterval
  public let id: Int
  public let recipient: User
  public let sender: User
}

extension Message: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<Message> {
    return curry(Message.init)
      <^> json <| "body"
      <*> json <| "created_at"
      <*> json <| "id"
      <*> json <| "recipient"
      <*> json <| "sender"
  }
}

extension Message: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case id, body, recipient, sender
    case createdAt = "created_at"
  }
}
