import Foundation
import Prelude

public struct DiscoveryParams {
  public var backed: Bool?
  public var category: Category?
  public var collaborated: Bool?
  public var created: Bool?
  public var hasVideo: Bool?
  public var includePOTD: Bool?
  public var page: Int?
  public var perPage: Int?
  public var query: String?
  public var recommended: Bool?
  public var seed: Int?
  public var similarTo: Project?
  public var social: Bool?
  public var sort: Sort?
  public var staffPicks: Bool?
  public var starred: Bool?
  public var state: State?
  public var tagId: TagID?

  public enum State: String, Decodable {
    case all
    case live
    case successful
  }

  public enum Sort: String, Decodable {
    case endingSoon = "end_date"
    case magic
    case newest
    case popular = "popularity"
  }

  public enum TagID: String, Decodable {
    case goRewardless = "518"
  }

  public static let defaults = DiscoveryParams(
    backed: nil, category: nil, collaborated: nil,
    created: nil, hasVideo: nil, includePOTD: nil,
    page: nil, perPage: nil, query: nil, recommended: nil,
    seed: nil, similarTo: nil, social: nil, sort: nil,
    staffPicks: nil, starred: nil, state: nil, tagId: nil
  )

  public static let recommendedDefaults = DiscoveryParams.defaults
    |> DiscoveryParams.lens.includePOTD .~ true
    |> DiscoveryParams.lens.backed .~ false
    |> DiscoveryParams.lens.recommended .~ true

  public var queryParams: [String: String] {
    var params: [String: String] = [:]
    params["backed"] = self.backed == true ? "1" : self.backed == false ? "-1" : nil
    params["category_id"] = self.category?.intID?.description
    params["collaborated"] = self.collaborated?.description
    params["created"] = self.created?.description
    params["has_video"] = self.hasVideo?.description
    params["page"] = self.page?.description
    params["per_page"] = self.perPage?.description
    params["recommended"] = self.recommended?.description
    params["seed"] = self.seed?.description
    params["similar_to"] = self.similarTo?.id.description
    params["social"] = self.social == true ? "1" : self.social == false ? "-1" : nil
    params["sort"] = self.sort?.rawValue
    params["staff_picks"] = self.staffPicks?.description
    params["starred"] = self.starred == true ? "1" : self.starred == false ? "-1" : nil
    params["state"] = self.state?.rawValue
    params["term"] = self.query
    params["tag_id"] = self.tagId?.rawValue

    return params
  }
}

extension DiscoveryParams: Equatable {}
public func == (a: DiscoveryParams, b: DiscoveryParams) -> Bool {
  return a.queryParams == b.queryParams
}

extension DiscoveryParams: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.description)
  }
}

extension DiscoveryParams: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return self.queryParams.description
  }

  public var debugDescription: String {
    return self.queryParams.debugDescription
  }
}

// MARK: - Decodable

extension DiscoveryParams: Decodable {
  private enum CodingKeys: String, CodingKey {
    case backed, category, collaborated, created, page, recommended, seed, social, sort, starred, state
    case hasVideo = "has_video"
    case includePOTD = "include_potd"
    case perPage = "per_page"
    case similarTo = "similar_to"
    case staffPicks = "staff_picks"
    case query = "term"
    case tagId = "tag_id"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    backed = try stringIntToBool(container.decodeOptional(.backed))
    category = container.decodeOptional(.category)
      ?? Category(id: "-1", name: "Unknown Category")
    collaborated = try stringToBool(container.decodeOptional(.collaborated))
    hasVideo = try stringToBool(container.decodeOptional(.hasVideo))
    includePOTD = try stringToBool(container.decodeOptional(.includePOTD))
    page = stringToInt(container.decodeOptional(.page))
    perPage = stringToInt(container.decodeOptional(.perPage))
    query = container.decodeOptional(.query)
    recommended = try stringToBool(container.decodeOptional(.recommended))
    seed = stringToInt(container.decodeOptional(.seed))
    similarTo = container.decodeOptional(.similarTo)
    social = try stringIntToBool(container.decodeOptional(.social))
    sort = container.decodeOptional(.sort)
    staffPicks = try stringToBool(container.decodeOptional(.staffPicks))
    starred = try stringIntToBool(container.decodeOptional(.starred))
    state = container.decodeOptional(.state)
    tagId = container.decodeOptional(.tagId)
  }
}

private func stringToBool(_ string: String?) throws -> Bool? {
  guard let string = string else { return nil }
  switch string {
  // taken from server's `value_to_boolean` function
  case "true", "1", "t", "T", "TRUE", "on", "ON":
    return true
  case "false", "0", "f", "F", "FALSE", "off", "OFF":
    return false
  default:
    throw DecoderError.underline("Could not parse string into bool.")
  }
}

private func stringToInt(_ string: String?) -> Int? {
  guard let string = string else { return nil }
  return
    Double(string).flatMap(Int.init)
      ?? Int(string)
      ?? 0
}

enum DecoderError: Error {
  case underline(String)
}

private func stringIntToBool(_ string: String?) throws -> Bool? {
  guard let string = string else { return nil }

  guard let number = Int(string), number <= 1 && number >= -1 else {
    throw DecoderError.underline("Could not parse string into bool.")
  }

  return number == 0 ? nil : number == 1
}
