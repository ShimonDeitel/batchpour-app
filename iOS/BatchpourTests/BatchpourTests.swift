import XCTest
@testable import Batchpour

@MainActor
final class BatchpourTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    func testSeedDataBelowFreeLimit() {
        XCTAssertLessThan(store.items.count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let before = store.items.count
        store.add(Pour(title: "Test Entry"))
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteDecreasesCount() {
        store.add(Pour(title: "To Delete"))
        let before = store.items.count
        store.delete(store.items[0])
        XCTAssertEqual(store.items.count, before - 1)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.items = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreWhenAtLimitAndNotPro() {
        store.isPro = false
        store.items = (0..<Store.freeLimit).map { _ in Pour(title: "x") }
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenProEvenAtLimit() {
        store.isPro = true
        store.items = (0..<Store.freeLimit).map { _ in Pour(title: "x") }
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateModifiesItem() {
        store.add(Pour(title: "Original"))
        var item = store.items[0]
        item.title = "Updated"
        store.update(item)
        XCTAssertEqual(store.items[0].title, "Updated")
    }

    func testPersistenceRoundTrip() {
        store.add(Pour(title: "Persisted"))
        store.save()
        let reloaded = Store()
        XCTAssertTrue(reloaded.items.contains { $0.title == "Persisted" })
    }
}
