import XCTest
@testable import SwiftIO

class BinaryReaderTests : XCTestCase {
    func testReadInt16() {
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0xFF, 0xFF])
        let reader = BinaryReader(stream)
        XCTAssertEqual(reader.readInt16(), 0x0201)
        XCTAssertEqual(reader.readInt16(), 0x0403)
        XCTAssertEqual(reader.readInt16(), -1)
    }

    func testReadInt16LittleEndian() {
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0xFF, 0xFF])
        let reader = BinaryReader(stream, endianess: .little)
        XCTAssertEqual(reader.readInt16(), 0x0201)
        XCTAssertEqual(reader.readInt16(), 0x0403)
        XCTAssertEqual(reader.readInt16(), -1)
    }

    func testReadInt16BigEndian() {
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0xFF, 0xFF])
        let reader = BinaryReader(stream, endianess: .big)
        XCTAssertEqual(reader.readInt16(), 0x0102)
        XCTAssertEqual(reader.readInt16(), 0x0304)
        XCTAssertEqual(reader.readInt16(), -1)
    }

    func testReadInt32() {
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0xFF, 0xFF, 0xFF, 0xFF])
        let reader = BinaryReader(stream)
        XCTAssertEqual(reader.readInt32(), 0x04030201)
        XCTAssertEqual(reader.readInt32(), -1)
    }

    func testReadInt64() {
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])
        let reader = BinaryReader(stream)
        XCTAssertEqual(reader.readInt64(), 0x0807060504030201)
        XCTAssertEqual(reader.readInt64(), -1)
    }

    func testReadChar() {
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A])
        let reader = BinaryReader(stream)
        XCTAssertEqual(reader.readChar(), "a")
        XCTAssertEqual(reader.readChar(), "b")
        XCTAssertEqual(reader.readChar(), "c")
        XCTAssertEqual(reader.readChar(), "d")
        XCTAssertEqual(reader.readChar(), "e")
        XCTAssertEqual(reader.readChar(), "f")
        XCTAssertEqual(reader.readChar(), "g")
        XCTAssertEqual(reader.readChar(), "h")
        XCTAssertEqual(reader.readChar(), "i")
        XCTAssertEqual(reader.readChar(), "j")
        XCTAssertEqual(reader.readChar(), "k")
        XCTAssertEqual(reader.readChar(), "l")
        XCTAssertEqual(reader.readChar(), "m")
        XCTAssertEqual(reader.readChar(), "n")
        XCTAssertEqual(reader.readChar(), "o")
        XCTAssertEqual(reader.readChar(), "p")
        XCTAssertEqual(reader.readChar(), "q")
        XCTAssertEqual(reader.readChar(), "r")
        XCTAssertEqual(reader.readChar(), "s")
        XCTAssertEqual(reader.readChar(), "t")
        XCTAssertEqual(reader.readChar(), "u")
        XCTAssertEqual(reader.readChar(), "v")
        XCTAssertEqual(reader.readChar(), "w")
        XCTAssertEqual(reader.readChar(), "x")
        XCTAssertEqual(reader.readChar(), "y")
        XCTAssertEqual(reader.readChar(), "z")
    }

    func testReadString() {
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A])
        let reader = BinaryReader(stream)
        XCTAssertEqual(reader.readString(26), "abcdefghijklmnopqrstuvwxyz")
    }

    func testReadStringWithLength() {
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A])
        let reader = BinaryReader(stream)
        XCTAssertEqual(reader.readString(10), "abcdefghij")
        XCTAssertEqual(reader.readString(10), "klmnopqrst")
    }

    func testReadStringWithLengthAndEncoding() {
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A])
        let reader = BinaryReader(stream)
        XCTAssertEqual(reader.readString(10, encoding: .utf8), "abcdefghij")
        XCTAssertEqual(reader.readString(10, encoding: .utf8), "klmnopqrst")
    }

    func testReadStringWithNullTermination() {
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63, 0x00, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A])
        let reader = BinaryReader(stream)
        XCTAssertEqual(reader.readString(format: .zeroTerminated, encoding: .utf8), "abc")
        XCTAssertEqual(reader.readString(format: .zeroTerminated, encoding: .utf8), "defghijklmnopqrstuvwxyz")
    }
}
