import Foundation

public struct FindFriendsEnvelope {
  public let contactsImported: Bool
  public let urls: UrlsEnvelope
  public let users: [User]

  public struct UrlsEnvelope {
    public let api: ApiEnvelope

    public struct ApiEnvelope {
      public let moreUsers: String?
    }
  }
}

// MARK: - Swift decodable

extension FindFriendsEnvelope: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case urls, users
    case contactsImported = "contacts_imported"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    urls = try container.decode(.urls)
    users = container.decodeArray(.users)
    contactsImported = try container.decode(.contactsImported)
  }
}

extension FindFriendsEnvelope.UrlsEnvelope: Swift.Decodable {}

extension FindFriendsEnvelope.UrlsEnvelope.ApiEnvelope: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case moreUsers = "more_users"
  }
}
