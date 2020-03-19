import Foundation

public struct AccessTokenEnvelope {
  public let accessToken: String
  public let user: User
}

extension AccessTokenEnvelope: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case user
  }
}
