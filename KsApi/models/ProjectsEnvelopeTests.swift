@testable import KsApi
import XCTest

internal final class ProjectsEnvelopeTests: XCTestCase {

  func testJSONDecoding() throws {
    let envelope = try ProjectsEnvelope.decodeJSON([
      "projects": [
        [
          "id": 3,
          "name": "Project",
          "blurb": "The project blurb",
          "staff_pick": false,
          "pledged": 1_000,
          "goal": 2_000,
          "category": [
            "id": 3,
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
              "project": "https://www.kickstarter.com/projects/my-cool-projects"
            ]
          ],
          "state": "live",
          "is_backing": true,
          "is_starred": true
        ]
      ],
      "urls": [
        "api": [
          "more_projects": "test"
        ]
      ]
    ]).get()

    XCTAssertEqual("test", envelope.urls.api.moreProjects)
    XCTAssertEqual(1, envelope.projects.count)
    XCTAssertEqual(3, envelope.projects.first?.id)
  }

  func testJSONDecoding_withoutActivities() throws {
    let envelope = try ProjectsEnvelope.decodeJSON([
      "projects": [],
      "urls": [
        "api": [:]
      ]
      ]).get()

    XCTAssertEqual("", envelope.urls.api.moreProjects)
    XCTAssertEqual([], envelope.projects)
  }
}
