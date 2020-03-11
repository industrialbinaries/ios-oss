import Foundation

public struct SurveyResponse {
  public let answeredAt: TimeInterval?
  public let id: Int
  public let project: Project?
  public let urls: UrlsEnvelope

  public struct UrlsEnvelope: Decodable {
    public let web: WebEnvelope

    public struct WebEnvelope: Decodable {
      public let survey: String
    }
  }
}

extension SurveyResponse: Equatable {}
public func == (lhs: SurveyResponse, rhs: SurveyResponse) -> Bool {
  return lhs.id == rhs.id
}

extension SurveyResponse: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case id, project, urls
    case answeredAt = "answered_at"
  }
}
