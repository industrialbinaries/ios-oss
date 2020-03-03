import Foundation

public struct ExportDataEnvelope {
  public let expiresAt: String?
  public let state: State
  public let dataUrl: String?

  public enum State: String {
    case queued
    case processing
    case completed
    case expired
  }
}

extension ExportDataEnvelope: Swift.Decodable {
  enum CodingKeys: String, CodingKey {
    case expiresAt = "expires_at"
    case state
    case dataUrl = "data_url"
  }
}

extension ExportDataEnvelope.State: Swift.Decodable {}
