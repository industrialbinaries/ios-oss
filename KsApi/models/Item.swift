import Foundation

public struct Item {
  public let description: String?
  public let id: Int
  public let name: String
  public let projectId: Int
}

extension Item: Decodable {
  private enum CodingKeys: String, CodingKey {
    case id, description, name
    case projectId = "project_id"
  }
}
