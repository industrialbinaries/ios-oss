import Foundation

public struct MessageThread {
  public let backing: Backing?
  public let closed: Bool
  public let id: Int
  public let lastMessage: Message
  public let participant: User
  public let project: Project
  public let unreadMessagesCount: Int
}

extension MessageThread: Equatable {}
public func == (lhs: MessageThread, rhs: MessageThread) -> Bool {
  return lhs.id == rhs.id
}

extension MessageThread: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case backing, id, closed, participant, project
    case unreadMessagesCount = "unread_messages_count"
    case lastMessage = "last_message"
  }
}
