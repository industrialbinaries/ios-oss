@testable import KsApi
import XCTest

final class NewsletterSubscriptionsTests: XCTestCase {
  func testJsonEncoding() throws {
    let json: [String: Any] = [
      "games_newsletter": false,
      "promo_newsletter": false,
      "happening_newsletter": false,
      "weekly_newsletter": false
    ]

    let newsletter = try User.NewsletterSubscriptions.decodeJSON(json).get()

    // swiftlint:disable:next force_unwrapping
    let newsletterDescription = newsletter.encode().description

    XCTAssertTrue(newsletterDescription.contains("games_newsletter\": false"))
    XCTAssertTrue(newsletterDescription.contains("happening_newsletter\": false"))
    XCTAssertTrue(newsletterDescription.contains("promo_newsletter\": false"))
    XCTAssertTrue(newsletterDescription.contains("weekly_newsletter\": false"))

    XCTAssertEqual(false, newsletter.weekly)
    XCTAssertEqual(false, newsletter.promo)
    XCTAssertEqual(false, newsletter.happening)
    XCTAssertEqual(false, newsletter.games)
  }

  func testJsonEncoding_TrueValues() throws {
    let json: [String: Any] = [
      "games_newsletter": true,
      "promo_newsletter": true,
      "happening_newsletter": true,
      "weekly_newsletter": true
    ]

    let newsletter = try User.NewsletterSubscriptions.decodeJSON(json).get()

    // swiftlint:disable:next force_unwrapping
    let newsletterDescription = newsletter.encode().description

    XCTAssertTrue(newsletterDescription.contains("games_newsletter\": true"))
    XCTAssertTrue(newsletterDescription.contains("promo_newsletter\": true"))
    XCTAssertTrue(newsletterDescription.contains("happening_newsletter\": true"))
    XCTAssertTrue(newsletterDescription.contains("weekly_newsletter\": true"))

    XCTAssertEqual(true, newsletter.weekly)
    XCTAssertEqual(true, newsletter.promo)
    XCTAssertEqual(true, newsletter.happening)
    XCTAssertEqual(true, newsletter.games)
  }

  func testJsonDecoding() throws {
    let newsletters = try User.NewsletterSubscriptions.decodeJSON([
      "games_newsletter": true,
      "happening_newsletter": false,
      "promo_newsletter": true,
      "weekly_newsletter": false
      ]).get()

    XCTAssertEqual(
      newsletters,
      try User.NewsletterSubscriptions.decodeJSON(newsletters.encode()).get()
    )
  }
}
