import XCTest
@testable import Sticker

final class StickerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Sticker().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
