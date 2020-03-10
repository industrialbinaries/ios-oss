@testable import KsApi
import XCTest

internal final class StarEnvelopeTests: XCTestCase {
  func testDecoding() throws {
    let tokenEnvelope = try StarEnvelope.decodeJSON([
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
      ],
      "project": [
        "id": 2,
        "name": "Project",
        "blurb": "The project blurb",
        "staff_pick": false,
        "pledged": 1_000,
        "goal": 2_000,
        "category": [
          "id": 1,
          "name": "Art",
          "parent_id": 5,
          "parent_name": "Parent Category",
          "slug": "art",
          "position": 1
        ],
        "creator": [
          "id": 1,
          "name": "Blob",
          "avatar": [
            "medium": "http://www.kickstarter.com/medium.jpg",
            "small": "http://www.kickstarter.com/small.jpg"
          ]
        ],
        "photo": [
          "full": "http://www.kickstarter.com/full.jpg",
          "med": "http://www.kickstarter.com/med.jpg",
          "small": "http://www.kickstarter.com/small.jpg",
          "1024x768": "http://www.kickstarter.com/1024x768.jpg"
        ],
        "location": [
          "country": "US",
          "id": 1,
          "displayable_name": "Brooklyn, NY",
          "name": "Brooklyn"
        ],
        "video": [
          "id": 1,
          "high": "kickstarter.com/video.mp4"
        ],
        "backers_count": 10,
        "currency_symbol": "$",
        "currency": "USD",
        "currency_trailing_code": false,
        "country": "US",
        "launched_at": 1_000,
        "deadline": 1_000,
        "state_changed_at": 1_000,
        "static_usd_rate": 1.0,
        "slug": "project",
        "urls": [
          "web": [
            "project": "https://www.kickstarter.com/projects/blob/project"
          ]
        ],
        "state": "live"
      ]
    ]).get()

    XCTAssertEqual(1, tokenEnvelope.user.id)
    XCTAssertEqual(2, tokenEnvelope.project.id)
  }
}
