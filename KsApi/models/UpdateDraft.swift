import Foundation

public struct UpdateDraft {
  public let update: Update
  public let images: [Image]
  public let video: Video?

  public enum Attachment {
    case image(Image)
    case video(Video)
  }

  public struct Image: Decodable {
    public let id: Int
    public let thumb: String
    public let full: String
  }

  public struct Video: Decodable {
    public let id: Int
    public let status: Status
    public let frame: String

    public enum Status: String, Decodable {
      case processing
      case failed
      case successful
    }
  }
}

extension UpdateDraft: Equatable {}
public func == (lhs: UpdateDraft, rhs: UpdateDraft) -> Bool {
  return lhs.update.id == rhs.update.id
}

extension UpdateDraft.Attachment {
  public var id: Int {
    switch self {
    case let .image(image):
      return image.id
    case let .video(video):
      return video.id
    }
  }

  public var thumbUrl: String {
    switch self {
    case let .image(image):
      return image.full
    case let .video(video):
      return video.frame
    }
  }
}

extension UpdateDraft.Attachment: Equatable {}
public func == (lhs: UpdateDraft.Attachment, rhs: UpdateDraft.Attachment) -> Bool {
  return lhs.id == rhs.id
}

// MARK: - Decodable

extension UpdateDraft: Decodable {
  private enum CodingKeys: String, CodingKey {
    case images, video
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    images = container.decodeArray(.images)
    video = container.decodeOptional(.video)
    update = try .init(from: decoder)
  }
}
