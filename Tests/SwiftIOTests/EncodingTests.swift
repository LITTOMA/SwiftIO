import XCTest
@testable import SwiftIO

class EncodingTests: XCTestCase {
    func testAsciiEncoding() {
        let encoding = ASCIIEncoding()
        let s = "Hello, world!"
        let bytes = encoding.getBytes(s)
        let s2 = encoding.getString(bytes)
        XCTAssertEqual(s, s2)
        XCTAssertEqual(bytes, [72, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33])
    }

    func testUtf8Encoding() {
        let encoding = UTF8Encoding()
        let s = "你好，世界！"
        let bytes = encoding.getBytes(s)
        let s2 = encoding.getString(bytes)
        XCTAssertEqual(s, s2)
        XCTAssertEqual(bytes, [228, 189, 160, 229, 165, 189, 239, 188, 140, 228, 184, 150, 231, 149, 140, 239, 188, 129])
    }

    func testUtf16Encoding() {
        let encoding = UTF16Encoding()
        let s = "你好，世界！"
        let bytes = encoding.getBytes(s)
        let s2 = encoding.getString(bytes)
        XCTAssertEqual(s, s2)
        XCTAssertEqual(bytes, [96, 79, 125, 89, 12, 255, 22, 78, 76, 117, 1, 255])
    }

    func testBigEndianUtf16Encoding() {
        let encoding = BigEndianUTF16Encoding()
        let s = "你好，世界！"
        let bytes = encoding.getBytes(s)
        let s2 = encoding.getString(bytes)
        XCTAssertEqual(s, s2)
        XCTAssertEqual(bytes, [79, 96, 89, 125, 255, 12, 78, 22, 117, 76, 255, 1])
    }
}
