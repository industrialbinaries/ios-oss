import Foundation

public struct PushEnvelope {
  public let activity: Activity?
  public let aps: ApsEnvelope
  public let forCreator: Bool?
  public let message: Message?
  public let project: Project?
  public let survey: Survey?
  public let update: Update?

  public struct Activity {
    public let category: KsApi.Activity.Category
    public let commentId: Int?
    public let id: Int
    public let projectId: Int?
    public let projectPhoto: String?
    public let updateId: Int?
    public let userPhoto: String?
  }

  public struct ApsEnvelope: Decodable {
    public let alert: String
  }

  public struct Message {
    public let messageThreadId: Int
    public let projectId: Int
  }

  public struct Project: Decodable {
    public let id: Int
    public let photo: String?
  }

  public struct Survey {
    public let id: Int
    public let projectId: Int
  }

  public struct Update {
    public let id: Int
    public let projectId: Int
  }
}

// MARK: - Decodable

extension PushEnvelope: Decodable {
  private enum CodingKeys: String, CodingKey {
    case update, post, activity, aps, message, project, survey
    case forCreator = "for_creator"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    update = container.decodeOptional(.update)
      ?? container.decodeOptional(.post)
    activity = container.decodeOptional(.activity)
    aps = try container.decode(.aps)
    message = container.decodeOptional(.message)
    project = container.decodeOptional(.project)
    survey = container.decodeOptional(.survey)
    forCreator = container.decodeOptional(.forCreator)
  }
}

extension PushEnvelope.Activity: Decodable {
  private enum CodingKeys: String, CodingKey {
    case id, category
    case commentId = "comment_id"
    case projectId = "project_id"
    case projectPhoto = "project_photo"
    case updateId = "update_id"
    case userPhoto = "user_photo"
  }
}

extension PushEnvelope.Message: Decodable {
  private enum CodingKeys: String, CodingKey {
    case projectId = "project_id"
    case messageThreadId = "message_thread_id"
  }
}

extension PushEnvelope.Survey: Decodable {
  private enum CodingKeys: String, CodingKey {
    case projectId = "project_id"
    case id
  }
}

extension PushEnvelope.Update: Decodable {
  private enum CodingKeys: String, CodingKey {
    case projectId = "project_id"
    case id
  }
}

