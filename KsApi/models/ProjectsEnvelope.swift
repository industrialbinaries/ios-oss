import Foundation

public struct ProjectsEnvelope: Decodable {

  public let projects: [Project]
  public let urls: UrlsEnvelope

  public struct UrlsEnvelope: Decodable {
    public let api: ApiEnvelope

    public struct ApiEnvelope {
      public let moreProjects: String
    }
  }
}

extension ProjectsEnvelope.UrlsEnvelope.ApiEnvelope: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case moreProjects = "more_projects"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    moreProjects = container.decodeOptional(.moreProjects)
      ?? ""
  }
}

