import XCTest
@testable import SwiftIO

class BinaryReaderTests : XCTestCase {
    func testReadInt16() throws {
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0xFF, 0xFF])
        let reader = BinaryReader(stream)
        XCTAssertEqual(try reader.readInt16(), 0x0201)
        XCTAssertEqual(try reader.readInt16(), 0x0403)
        XCTAssertEqual(try reader.readInt16(), -1)
    }

    func testReadInt16LittleEndian() throws {
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0xFF, 0xFF])
        let reader = BinaryReader(stream, endianess: .little)
        XCTAssertEqual(try reader.readInt16(), 0x0201)
        XCTAssertEqual(try reader.readInt16(), 0x0403)
        XCTAssertEqual(try reader.readInt16(), -1)
    }

    func testReadInt16BigEndian() throws {
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0xFF, 0xFF])
        let reader = BinaryReader(stream, endianess: .big)
        XCTAssertEqual(try reader.readInt16(), 0x0102)
        XCTAssertEqual(try reader.readInt16(), 0x0304)
        XCTAssertEqual(try reader.readInt16(), -1)
    }

    func testReadInt32() throws {
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0xFF, 0xFF, 0xFF, 0xFF])
        let reader = BinaryReader(stream)
        XCTAssertEqual(try reader.readInt32(), 0x04030201)
        XCTAssertEqual(try reader.readInt32(), -1)
    }

    func testReadInt64() throws {
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])
        let reader = BinaryReader(stream)
        XCTAssertEqual(try reader.readInt64(), 0x0807060504030201)
        XCTAssertEqual(try reader.readInt64(), -1)
    }

    func testReadChar() throws {
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A])
        let reader = BinaryReader(stream)
        XCTAssertEqual(try reader.readChar(), "a")
        XCTAssertEqual(try reader.readChar(), "b")
        XCTAssertEqual(try reader.readChar(), "c")
        XCTAssertEqual(try reader.readChar(), "d")
        XCTAssertEqual(try reader.readChar(), "e")
        XCTAssertEqual(try reader.readChar(), "f")
        XCTAssertEqual(try reader.readChar(), "g")
        XCTAssertEqual(try reader.readChar(), "h")
        XCTAssertEqual(try reader.readChar(), "i")
        XCTAssertEqual(try reader.readChar(), "j")
        XCTAssertEqual(try reader.readChar(), "k")
        XCTAssertEqual(try reader.readChar(), "l")
        XCTAssertEqual(try reader.readChar(), "m")
        XCTAssertEqual(try reader.readChar(), "n")
        XCTAssertEqual(try reader.readChar(), "o")
        XCTAssertEqual(try reader.readChar(), "p")
        XCTAssertEqual(try reader.readChar(), "q")
        XCTAssertEqual(try reader.readChar(), "r")
        XCTAssertEqual(try reader.readChar(), "s")
        XCTAssertEqual(try reader.readChar(), "t")
        XCTAssertEqual(try reader.readChar(), "u")
        XCTAssertEqual(try reader.readChar(), "v")
        XCTAssertEqual(try reader.readChar(), "w")
        XCTAssertEqual(try reader.readChar(), "x")
        XCTAssertEqual(try reader.readChar(), "y")
        XCTAssertEqual(try reader.readChar(), "z")
    }

    func testReadString() throws {
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A])
        let reader = BinaryReader(stream)
        XCTAssertEqual(try reader.readString(26), "abcdefghijklmnopqrstuvwxyz")
    }

    func testReadStringWithLength() throws {
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A])
        let reader = BinaryReader(stream)
        XCTAssertEqual(try reader.readString(10), "abcdefghij")
        XCTAssertEqual(try reader.readString(10), "klmnopqrst")
    }

    func testReadStringWithLengthAndEncoding() throws {
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A])
        let reader = BinaryReader(stream)
        XCTAssertEqual(try reader.readString(10, encoding: .utf8), "abcdefghij")
        XCTAssertEqual(try reader.readString(10, encoding: .utf8), "klmnopqrst")
    }

    func testReadStringWithNullTermination() throws {
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63, 0x00, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A])
        let reader = BinaryReader(stream)
        XCTAssertEqual(try reader.readString(format: .zeroTerminated, encoding: .utf8), "abc")
        XCTAssertEqual(try reader.readString(format: .zeroTerminated, encoding: .utf8), "defghijklmnopqrstuvwxyz")
    }

    func testReadUtf8Char() throws {
        let stream = MemoryStream(bytes: [0x61, 0xC3, 0xA9, 0x63, 0x64, 0x65])
        let reader = BinaryReader(stream)
        XCTAssertEqual(try reader.readChar(encoding: .utf8), "a")
        XCTAssertEqual(try reader.readChar(encoding: .utf8), "é")
        XCTAssertEqual(try reader.readChar(encoding: .utf8), "c")
        XCTAssertEqual(try reader.readChar(encoding: .utf8), "d")
        XCTAssertEqual(try reader.readChar(encoding: .utf8), "e")
    }
}
