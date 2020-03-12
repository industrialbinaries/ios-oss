import Foundation

public struct ErrorEnvelope {
  public let errorMessages: [String]
  public let ksrCode: KsrCode?
  public let httpCode: Int
  public let exception: Exception?
  public let facebookUser: FacebookUser?

  public init(
    errorMessages: [String], ksrCode: KsrCode?, httpCode: Int, exception: Exception?,
    facebookUser: FacebookUser? = nil
  ) {
    self.errorMessages = errorMessages
    self.ksrCode = ksrCode
    self.httpCode = httpCode
    self.exception = exception
    self.facebookUser = facebookUser
  }

  public enum KsrCode: String {
    // Codes defined by the server
    case AccessTokenInvalid = "access_token_invalid"
    case ConfirmFacebookSignup = "confirm_facebook_signup"
    case FacebookConnectAccountTaken = "facebook_connect_account_taken"
    case FacebookConnectEmailTaken = "facebook_connect_email_taken"
    case FacebookInvalidAccessToken = "facebook_invalid_access_token"
    case InvalidXauthLogin = "invalid_xauth_login"
    case MissingFacebookEmail = "missing_facebook_email"
    case TfaFailed = "tfa_failed"
    case TfaRequired = "tfa_required"

    // Catch all code for when server sends code we don't know about yet
    case UnknownCode = "__internal_unknown_code"

    // Codes defined by the client
    case JSONParsingFailed = "json_parsing_failed"
    case ErrorEnvelopeJSONParsingFailed = "error_json_parsing_failed"
    case DecodingJSONFailed = "decoding_json_failed"
    case InvalidPaginationUrl = "invalid_pagination_url"
  }

  public struct Exception {
    public let backtrace: [String]?
    public let message: String?
  }

  public struct FacebookUser {
    public let id: Int64
    public let name: String
    public let email: String
  }

  /**
   A general error that JSON could not be parsed.
   */
  internal static let couldNotParseJSON = ErrorEnvelope(
    errorMessages: [],
    ksrCode: .JSONParsingFailed,
    httpCode: 400,
    exception: nil,
    facebookUser: nil
  )

  /**
   A general error that the error envelope JSON could not be parsed.
   */
  internal static let couldNotParseErrorEnvelopeJSON = ErrorEnvelope(
    errorMessages: [],
    ksrCode: .ErrorEnvelopeJSONParsingFailed,
    httpCode: 400,
    exception: nil,
    facebookUser: nil
  )

  /**
   A general error that some JSON could not be decoded.

   - parameter decodeError: The decoding error.

   - returns: An error envelope that describes why decoding failed.
   */
  static func couldNotDecodeJSON(_ error: Error) -> ErrorEnvelope {
    return ErrorEnvelope(
      errorMessages: ["Swift decoding error: \(error.localizedDescription)"],
      ksrCode: .DecodingJSONFailed,
      httpCode: 400, // TODO: 🤔 I am not sure it should be 400 http code when parsing failed
      exception: nil,
      facebookUser: nil
    )
  }

  /**
   A error that the pagination URL is invalid.

   - parameter decodeError: The Argo decoding error.

   - returns: An error envelope that describes why decoding failed.
   */
  internal static let invalidPaginationUrl = ErrorEnvelope(
    errorMessages: [],
    ksrCode: .InvalidPaginationUrl,
    httpCode: 400,
    exception: nil,
    facebookUser: nil
  )
}

extension ErrorEnvelope: Error {}

// MARK: - Swift decodable

extension ErrorEnvelope.FacebookUser: Swift.Decodable {}

extension ErrorEnvelope.KsrCode: Swift.Decodable {
  public init(from decoder: Decoder) throws {
    guard
      let container = try? decoder.singleValueContainer(),
      let code = try? container.decode(String.self)
      else {
        self = ErrorEnvelope.KsrCode.UnknownCode
        return
    }
    self =  ErrorEnvelope.KsrCode(rawValue: code) ?? ErrorEnvelope.KsrCode.UnknownCode
  }
}

extension ErrorEnvelope.Exception: Swift.Decodable {}

extension ErrorEnvelope: Swift.Decodable {
  private enum CodingKeys: String, CodingKey {
    case errorMessages = "error_messages"
    case ksrCode = "ksr_code"
    case httpCode = "http_code"
    case exception = "exception"
    case facebookUser = "facebook_user"
    case status
    case data
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      httpCode = try container.decode(.httpCode)
      errorMessages = container.decodeArray(.errorMessages)
      ksrCode = container.decodeOptional(.ksrCode)
      exception = container.decodeOptional(.exception)
      facebookUser = container.decodeOptional(.facebookUser)
    } catch {

      let data: [String: [String: [String]]]? = container.decodeOptional(.data)
      let amount = data?["errors"]?["amount"] ?? []
      let backerReward = data?["errors"]?["backer_reward"] ?? []
      errorMessages = amount + backerReward
      ksrCode = ErrorEnvelope.KsrCode.UnknownCode
      httpCode = try container.decode(.status)
      exception = nil
      facebookUser = nil
    }
  }
}
