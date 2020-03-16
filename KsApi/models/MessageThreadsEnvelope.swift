import Foundation

public struct MessageThreadsEnvelope {
  public let messageThreads: [MessageThread]
  public let urls: UrlsEnvelope

  public struct UrlsEnvelope {
    public let api: ApiEnvelope

    public struct ApiEnvelope {
      public let moreMessageThreads: String
    }
  }
}

// MARK: - Swift decodable

extension MessageThreadsEnvelope: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case urls
    case messageThreads = "message_threads"
  }
}

extension MessageThreadsEnvelope.UrlsEnvelope: Swift.Decodable {}

extension MessageThreadsEnvelope.UrlsEnvelope.ApiEnvelope: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case moreMessageThreads = "more_message_threads"
  }
}
