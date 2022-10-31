import XCTest
@testable import SwiftIO

final class BinaryPrimitivesTests: XCTestCase {
    func testReadDoubleBigEndian () {
        let bytes = Data([0x3F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        let value = BinaryPrimitives.readDoubleBigEndian(from: bytes)
        XCTAssertEqual(value, 1.0)
    }

    func testReadDoubleLittleEndian () {
        let bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F])
        let value = BinaryPrimitives.readDoubleLittleEndian(from: bytes)
        XCTAssertEqual(value, 1.0)
    }

    func testReadFloatBigEndian () {
        let bytes = Data([0x3F, 0x80, 0x00, 0x00])
        let value = BinaryPrimitives.readFloatBigEndian(from: bytes)
        XCTAssertEqual(value, 1.0)
    }

    func testReadFloatLittleEndian () {
        let bytes = Data([0x00, 0x00, 0x80, 0x3F])
        let value = BinaryPrimitives.readFloatLittleEndian(from: bytes)
        XCTAssertEqual(value, 1.0)
    }

    func testReadInt16BigEndian () {
        let bytes = Data([0x00, 0x01])
        let value = BinaryPrimitives.readInt16BigEndian(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testReadInt16LittleEndian () {
        let bytes = Data([0x01, 0x00])
        let value = BinaryPrimitives.readInt16LittleEndian(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testReadInt32BigEndian () {
        let bytes = Data([0x00, 0x00, 0x00, 0x01])
        let value = BinaryPrimitives.readInt32BigEndian(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testReadInt32LittleEndian () {
        let bytes = Data([0x01, 0x00, 0x00, 0x00])
        let value = BinaryPrimitives.readInt32LittleEndian(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testReadInt64BigEndian () {
        let bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01])
        let value = BinaryPrimitives.readInt64BigEndian(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testReadInt64LittleEndian () {
        let bytes = Data([0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        let value = BinaryPrimitives.readInt64LittleEndian(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testReadInt8 () {
        let bytes = Data([0x01])
        let value = BinaryPrimitives.readInt8(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testReadSingleBigEndian () {
        let bytes = Data([0x3F, 0x80, 0x00, 0x00])
        let value = BinaryPrimitives.readSingleBigEndian(from: bytes)
        XCTAssertEqual(value, 1.0)
    }

    func testReadSingleLittleEndian () {
        let bytes = Data([0x00, 0x00, 0x80, 0x3F])
        let value = BinaryPrimitives.readSingleLittleEndian(from: bytes)
        XCTAssertEqual(value, 1.0)
    }

    func testReadUInt16BigEndian () {
        let bytes = Data([0x00, 0x01])
        let value = BinaryPrimitives.readUInt16BigEndian(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testReadUInt16LittleEndian () {
        let bytes = Data([0x01, 0x00])
        let value = BinaryPrimitives.readUInt16LittleEndian(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testReadUInt32BigEndian () {
        let bytes = Data([0x00, 0x00, 0x00, 0x01])
        let value = BinaryPrimitives.readUInt32BigEndian(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testReadUInt32LittleEndian () {
        let bytes = Data([0x01, 0x00, 0x00, 0x00])
        let value = BinaryPrimitives.readUInt32LittleEndian(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testReadUInt64BigEndian () {
        let bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01])
        let value = BinaryPrimitives.readUInt64BigEndian(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testReadUInt64LittleEndian () {
        let bytes = Data([0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        let value = BinaryPrimitives.readUInt64LittleEndian(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testReadUInt8 () {
        let bytes = Data([0x01])
        let value = BinaryPrimitives.readUInt8(from: bytes)
        XCTAssertEqual(value, 1)
    }

    func testWriteDoubleBigEndian () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeDoubleBigEndian(1.0, to: &bytes)
        XCTAssertEqual(bytes, Data([0x3F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]))
    }

    func testWriteDoubleBigEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeDoubleBigEndian(1.0, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x3F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]))
    }

    func testWriteDoubleLittleEndian () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeDoubleLittleEndian(1.0, to: &bytes)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F]))
    }

    func testWriteDoubleLittleEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeDoubleLittleEndian(1.0, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F]))
    }

    func testWriteInt16BigEndian () {
        var bytes = Data([0x00, 0x00])
        BinaryPrimitives.writeInt16BigEndian(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x00, 0x01]))
    }

    func testWriteInt16BigEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeInt16BigEndian(1, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x00, 0x01]))
    }

    func testWriteInt16LittleEndian () {
        var bytes = Data([0x00, 0x00])
        BinaryPrimitives.writeInt16LittleEndian(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x01, 0x00]))
    }

    func testWriteInt16LittleEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeInt16LittleEndian(1, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x01, 0x00]))
    }

    func testWriteInt32BigEndian () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeInt32BigEndian(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x00, 0x01]))
    }

    func testWriteInt32BigEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeInt32BigEndian(1, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x01]))
    }

    func testWriteInt32LittleEndian () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeInt32LittleEndian(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x01, 0x00, 0x00, 0x00]))
    }

    func testWriteInt32LittleEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeInt32LittleEndian(1, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x01, 0x00, 0x00, 0x00]))
    }

    func testWriteInt64BigEndian () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeInt64BigEndian(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]))
    }

    func testWriteInt64BigEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeInt64BigEndian(1, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]))
    }

    func testWriteInt64LittleEndian () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeInt64LittleEndian(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]))
    }

    func testWriteInt64LittleEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeInt64LittleEndian(1, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]))
    }

    func testWriteInt8 () {
        var bytes = Data([0x00])
        BinaryPrimitives.writeInt8(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x01]))
    }

    func testWriteInt8WithOffset () {
        var bytes = Data([0x00, 0x00])
        BinaryPrimitives.writeInt8(1, to: &bytes, at: 1)
        XCTAssertEqual(bytes, Data([0x00, 0x01]))
    }

    func testWriteSingleBigEndian () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeSingleBigEndian(1.0, to: &bytes)
        XCTAssertEqual(bytes, Data([0x3F, 0x80, 0x00, 0x00]))
    }

    func testWriteSingleBigEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeSingleBigEndian(1.0, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x3F, 0x80, 0x00, 0x00]))
    }

    func testWriteSingleLittleEndian () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeSingleLittleEndian(1.0, to: &bytes)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x80, 0x3F]))
    }

    func testWriteSingleLittleEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeSingleLittleEndian(1.0, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x00, 0x00, 0x80, 0x3F]))
    }

    func testWriteUInt16BigEndian () {
        var bytes = Data([0x00, 0x00])
        BinaryPrimitives.writeUInt16BigEndian(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x00, 0x01]))
    }

    func testWriteUInt16BigEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeUInt16BigEndian(1, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x00, 0x01]))
    }

    func testWriteUInt16LittleEndian () {
        var bytes = Data([0x00, 0x00])
        BinaryPrimitives.writeUInt16LittleEndian(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x01, 0x00]))
    }

    func testWriteUInt16LittleEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeUInt16LittleEndian(1, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x01, 0x00]))
    }

    func testWriteUInt32BigEndian () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeUInt32BigEndian(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x00, 0x01]))
    }

    func testWriteUInt32BigEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeUInt32BigEndian(1, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x01]))
    }

    func testWriteUInt32LittleEndian () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeUInt32LittleEndian(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x01, 0x00, 0x00, 0x00]))
    }

    func testWriteUInt32LittleEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeUInt32LittleEndian(1, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x01, 0x00, 0x00, 0x00]))
    }

    func testWriteUInt64BigEndian () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeUInt64BigEndian(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]))
    }

    func testWriteUInt64BigEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeUInt64BigEndian(1, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]))
    }

    func testWriteUInt64LittleEndian () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeUInt64LittleEndian(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]))
    }

    func testWriteUInt64LittleEndianWithOffset () {
        var bytes = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        BinaryPrimitives.writeUInt64LittleEndian(1, to: &bytes, at: 2)
        XCTAssertEqual(bytes, Data([0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]))
    }

    func testWriteUInt8 () {
        var bytes = Data([0x00])
        BinaryPrimitives.writeUInt8(1, to: &bytes)
        XCTAssertEqual(bytes, Data([0x01]))
    }

    func testWriteUInt8WithOffset () {
        var bytes = Data([0x00, 0x00])
        BinaryPrimitives.writeUInt8(1, to: &bytes, at: 1)
        XCTAssertEqual(bytes, Data([0x00, 0x01]))
    }
}