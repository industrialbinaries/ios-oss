import Foundation

public struct MessageThreadEnvelope {
  public let participants: [User]
  public let messages: [Message]
  public let messageThread: MessageThread
}

extension MessageThreadEnvelope: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case participants, messages
    case messageThread = "message_thread"
  }
}
