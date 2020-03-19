@testable import KsApi
import Prelude
import XCTest

final class BackingTests: XCTestCase {
  func testJSONDecoding_WithCompleteData() throws {
    let backing = try Backing.decodeJSON([
      "amount": 1.0,
      "backer_id": 1,
      "cancelable": true,
      "id": 1,
      "location_id": 1,
      "location_name": "United States",
      "payment_source": [
        "expiration_date": "2019-09-23",
        "id": "20",
        "last_four": "1234",
        "payment_type": "CREDIT_CARD",
        "state": "ACTIVE",
        "type": "VISA"
      ],
      "pledged_at": 1_000,
      "project_country": "US",
      "project_id": 1,
      "sequence": 1,
      "status": "pledged"
      ]).get()

    XCTAssertEqual(1.0, backing.amount)
    XCTAssertEqual(1, backing.backerId)
    XCTAssertEqual(true, backing.cancelable)
    XCTAssertEqual(1, backing.id)
    XCTAssertEqual("2019-09-23", backing.paymentSource?.expirationDate)
    XCTAssertEqual("20", backing.paymentSource?.id)
    XCTAssertEqual("1234", backing.paymentSource?.lastFour)
    XCTAssertEqual("CREDIT_CARD", backing.paymentSource?.paymentType.rawValue)
    XCTAssertEqual("ACTIVE", backing.paymentSource?.state)
    XCTAssertEqual(GraphUserCreditCard.CreditCardType.visa, backing.paymentSource?.type)
    XCTAssertEqual(1, backing.locationId)
    XCTAssertEqual("United States", backing.locationName)
    XCTAssertEqual(1_000, backing.pledgedAt)
    XCTAssertEqual("US", backing.projectCountry)
    XCTAssertEqual(1, backing.projectId)
    XCTAssertEqual(1, backing.sequence)
    XCTAssertEqual(Backing.Status.pledged, backing.status)
  }

  func testJSONDecoding_IncompletePaymentSource() throws {
    let backing = try Backing.decodeJSON([
      "amount": 1.0,
      "backer_id": 1,
      "cancelable": true,
      "id": 1,
      "location_id": 1,
      "location_name": "United States",
      "payment_source": [],
      "pledged_at": 1_000,
      "project_country": "US",
      "project_id": 1,
      "sequence": 1,
      "status": "pledged"
    ]).get()

    XCTAssertEqual(1.0, backing.amount)
    XCTAssertEqual(1, backing.backerId)
    XCTAssertEqual(1, backing.id)

    XCTAssertNil(backing.paymentSource)

    XCTAssertEqual(1, backing.locationId)
    XCTAssertEqual("United States", backing.locationName)
    XCTAssertEqual(1_000, backing.pledgedAt)
    XCTAssertEqual("US", backing.projectCountry)
    XCTAssertEqual(1, backing.projectId)
    XCTAssertEqual(1, backing.sequence)
    XCTAssertEqual(Backing.Status.pledged, backing.status)
  }

  func testPledgeAmount() {
    let backing = Backing.template
      |> Backing.lens.reward .~ Reward.postcards
      |> Backing.lens.rewardId .~ Reward.postcards.id
      |> Backing.lens.shippingAmount .~ 100
      |> Backing.lens.amount .~ 700.50

    XCTAssertEqual(backing.amount, 700.50)
    XCTAssertEqual(backing.pledgeAmount, 600.50)
  }
}
