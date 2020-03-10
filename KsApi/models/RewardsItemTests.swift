@testable import KsApi
import XCTest

final class RewardsItemTests: XCTestCase {
  func testDecoding() throws {
    let rewards = try RewardsItem.decodeJSON([
      "id": 1,
      "item": [
        "description": "Hello",
        "id": 1,
        "name": "The thing",
        "project_id": 1
      ],
      "quantity": 2,
      "reward_id": 3
      ]).get()

    XCTAssertEqual(1, rewards.id)
    XCTAssertEqual(2, rewards.quantity)
    XCTAssertEqual(3, rewards.rewardId)

    XCTAssertEqual("Hello", rewards.item.description)
    XCTAssertEqual(1, rewards.item.id)
    XCTAssertEqual("The thing", rewards.item.name)
    XCTAssertEqual(1, rewards.item.projectId)
  }
}
