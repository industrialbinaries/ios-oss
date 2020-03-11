import Argo
import Curry
import Runes

public struct ProjectsEnvelope {

  public let projects: [Project]
  public let urls: UrlsEnvelope

  public struct UrlsEnvelope {
    public let api: ApiEnvelope

    public struct ApiEnvelope {
      public let moreProjects: String
    }
  }
}

extension ProjectsEnvelope: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<ProjectsEnvelope> {
    return curry(ProjectsEnvelope.init)
      <^> json <|| "projects"
      <*> json <| "urls"
  }
}

extension ProjectsEnvelope.UrlsEnvelope: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<ProjectsEnvelope.UrlsEnvelope> {
    return curry(ProjectsEnvelope.UrlsEnvelope.init)
      <^> json <| "api"
  }
}

extension ProjectsEnvelope.UrlsEnvelope.ApiEnvelope: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<ProjectsEnvelope.UrlsEnvelope.ApiEnvelope> {
    return curry(ProjectsEnvelope.UrlsEnvelope.ApiEnvelope.init)
      <^> (json <| "more_projects" <|> .success(""))
  }
}

// MARK: - Swift decodable

extension ProjectsEnvelope: Swift.Decodable {}

extension ProjectsEnvelope.UrlsEnvelope: Swift.Decodable {}

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

