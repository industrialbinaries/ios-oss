import Foundation

public struct DiscoveryEnvelope: Decodable {
  public let projects: [Project]
  public let urls: UrlsEnvelope
  public let stats: StatsEnvelope

  public struct UrlsEnvelope: Decodable {
    public let api: ApiEnvelope

    public struct ApiEnvelope {
      public let moreProjects: String

      public init(more_projects: String) {
        self.moreProjects = more_projects
      }
    }
  }

  public struct StatsEnvelope: Decodable {
    public let count: Int
  }
}

extension DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope: Decodable {
  private enum CodingKeys: String, CodingKey {
    case moreProjects = "more_projects"
  }
}
