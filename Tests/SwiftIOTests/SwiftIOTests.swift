import XCTest
@testable import SwiftIO

final class SwiftIOTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftIO().text, "Hello, World!")
    }
}
