@testable import KsApi
import XCTest

internal final class ActivityTests: XCTestCase {
  func testEquatable() {
    XCTAssertEqual(Activity.template, Activity.template)
  }

  func testJSONDecoding_WithBadData() {
    let activity = Activity.decodeJSON([
      "category": "update"
      ])

    guard case let .failure(error) = activity else {
      XCTFail("Missing error value.")
      return
    }
    XCTAssertNotNil(error)
  }

  func testJSONDecoding_WithGoodData() throws {
    let activity = try Activity.decodeJSON([
      "category": "update",
      "created_at": 123_123_123,
      "id": 1
      ]).get()

    XCTAssertEqual(activity.id, 1)
  }

  func testJSONParsing_WithMemberData() throws {
    let memberData = try Activity.MemberData.decodeJSON([
      "amount": 25.0,
      "backing": [
        "amount": 1.0,
        "backer_id": 1,
        "cancelable": true,
        "id": 1,
        "location_id": 1,
        "pledged_at": 1_000,
        "project_country": "US",
        "project_id": 1,
        "sequence": 1,
        "status": "pledged"
      ],
      "old_amount": 15.0,
      "old_reward_id": 1,
      "new_amount": 25.0,
      "new_reward_id": 2,
      "reward_id": 2
      ]).get()

    XCTAssertEqual(25, memberData.amount)
    XCTAssertEqual(1, memberData.backing?.id)
    XCTAssertEqual(15, memberData.oldAmount)
    XCTAssertEqual(1, memberData.oldRewardId)
    XCTAssertEqual(25, memberData.newAmount)
    XCTAssertEqual(2, memberData.newRewardId)
    XCTAssertEqual(2, memberData.rewardId)
  }

  func testJSONDecoding_WithNestedGoodData() throws {
    let activity = try Activity.decodeJSON([
      "category": "update",
      "created_at": 123_123_123,
      "id": 1,
      "user": [
        "id": 2,
        "name": "User",
        "avatar": [
          "medium": "img.jpg",
          "small": "img.jpg",
          "large": "img.jpg"
        ]
      ]
      ]).get()

    XCTAssertEqual(activity.id, 1)
    XCTAssertEqual(activity.user?.id, 2)
  }

  func testJSONDecoding_WithIncorrectCategory() throws {
    let activity = try Activity.decodeJSON([
      "category": "incorrect_category",
      "created_at": 123_123_123,
      "id": 1
      ]).get()

    XCTAssertEqual(.unknown, activity.category)
  }
}
