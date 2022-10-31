import XCTest
@testable import SwiftIO

class EncodingTests: XCTestCase {
    func testAsciiEncoding() {
        let encoding = AsciiEncoding()
        let s = "Hello, world!"
        let bytes = encoding.getBytes(s)
        let s2 = encoding.getString(bytes)
        XCTAssertEqual(s, s2)
        XCTAssertEqual(bytes, [72, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33])
    }
}