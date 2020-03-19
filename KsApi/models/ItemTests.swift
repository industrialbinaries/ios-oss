@testable import KsApi
import XCTest

final class ItemTests: XCTestCase {
  func testDecoding() throws {
    let item = try Item.decodeJSON([
      "description": "Hello",
      "id": 1,
      "name": "The thing",
      "project_id": 1
      ]).get()

    XCTAssertEqual("Hello", item.description)
    XCTAssertEqual(1, item.id)
    XCTAssertEqual("The thing", item.name)
    XCTAssertEqual(1, item.projectId)
  }
}
