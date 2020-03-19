@testable import KsApi
import XCTest

internal final class AccessTokenEnvelopeTests: XCTestCase {
  func testDecoding() throws {
    let tokenEnvelope = try AccessTokenEnvelope.decodeJSON([
      "access_token": "token",
      "user":
        [
          "id": 1,
          "name": "Blob",
          "avatar": [
            "medium": "http://www.kickstarter.com/medium.jpg",
            "small": "http://www.kickstarter.com/small.jpg"
          ],
          "backed_projects_count": 2,
          "weekly_newsletter": false,
          "promo_newsletter": false,
          "happening_newsletter": false,
          "games_newsletter": false,
          "notify_of_comment_replies": false,
          "facebook_connected": false,
          "location": [
            "country": "US",
            "id": 12,
            "displayable_name": "Brooklyn, NY",
            "localized_name": "Brooklyn, NY",
            "name": "Brooklyn"
          ],
          "is_admin": false,
          "is_friend": false,
          "opted_out_of_recommendations": true,
          "show_public_profile": false,
          "social": true
      ]
    ]).get()

    XCTAssertEqual("token", tokenEnvelope.accessToken)
    XCTAssertEqual(1, tokenEnvelope.user.id)
  }
}
