import Argo
import Curry
import Runes

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

  public struct ApsEnvelope: Swift.Decodable {
    public let alert: String
  }

  public struct Message {
    public let messageThreadId: Int
    public let projectId: Int
  }

  public struct Project: Swift.Decodable {
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

extension PushEnvelope: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<PushEnvelope> {
    let update: Decoded<Update> = json <| "update" <|> json <| "post"
    let optionalUpdate: Decoded<Update?> = update.map(Optional.some) <|> .success(nil)

    let tmp = curry(PushEnvelope.init)
      <^> json <|? "activity"
      <*> json <| "aps"
      <*> json <|? "for_creator"
    return tmp
      <*> json <|? "message"
      <*> json <|? "project"
      <*> json <|? "survey"
      <*> optionalUpdate
  }
}

extension PushEnvelope.Activity: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<PushEnvelope.Activity> {
    let tmp = curry(PushEnvelope.Activity.init)
      <^> json <| "category"
      <*> json <|? "comment_id"
      <*> json <| "id"
      <*> json <|? "project_id"
    return tmp
      <*> json <|? "project_photo"
      <*> json <|? "update_id"
      <*> json <|? "user_photo"
  }
}

extension PushEnvelope.ApsEnvelope: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<PushEnvelope.ApsEnvelope> {
    return curry(PushEnvelope.ApsEnvelope.init)
      <^> json <| "alert"
  }
}

extension PushEnvelope.Message: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<PushEnvelope.Message> {
    return curry(PushEnvelope.Message.init)
      <^> json <| "message_thread_id"
      <*> json <| "project_id"
  }
}

extension PushEnvelope.Project: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<PushEnvelope.Project> {
    return curry(PushEnvelope.Project.init)
      <^> json <| "id"
      <*> json <|? "photo"
  }
}

extension PushEnvelope.Survey: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<PushEnvelope.Survey> {
    return curry(PushEnvelope.Survey.init)
      <^> json <| "id"
      <*> json <| "project_id"
  }
}

extension PushEnvelope.Update: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<PushEnvelope.Update> {
    return curry(PushEnvelope.Update.init)
      <^> json <| "id"
      <*> json <| "project_id"
  }
}

// MARK: - Swift decodable

extension PushEnvelope: Swift.Decodable {
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

extension PushEnvelope.Activity: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case id, category
    case commentId = "comment_id"
    case projectId = "project_id"
    case projectPhoto = "project_photo"
    case updateId = "update_id"
    case userPhoto = "user_photo"
  }
}

extension PushEnvelope.Message: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case projectId = "project_id"
    case messageThreadId = "message_thread_id"
  }
}

extension PushEnvelope.Survey: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case projectId = "project_id"
    case id
  }
}

extension PushEnvelope.Update: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case projectId = "project_id"
    case id
  }
}

