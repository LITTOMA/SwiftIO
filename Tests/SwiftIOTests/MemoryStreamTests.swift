import XCTest
@testable import SwiftIO

final class MemoryStreamTests: XCTestCase {
    func testMemoryStreamInitWithData() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        XCTAssertEqual(stream.length, 10)
        XCTAssertEqual(stream.position, 0)
        XCTAssertEqual(stream.readTimeout, 0)
        XCTAssertEqual(stream.writeTimeout, 0)
    }

    func testMemoryStreamInitWithArray() throws {
        let bytes = [UInt8](repeating: 0x00, count: 10)
        let stream = MemoryStream(bytes: bytes)
        XCTAssertEqual(stream.length, 10)
        XCTAssertEqual(stream.position, 0)
        XCTAssertEqual(stream.readTimeout, 0)
        XCTAssertEqual(stream.writeTimeout, 0)
    }

    func testMemoryStreamClose() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        XCTAssertEqual(stream.canRead, true)
        XCTAssertEqual(stream.canSeek, true)
        XCTAssertEqual(stream.canTimeout, true)
        XCTAssertEqual(stream.canWrite, true)
        
        stream.close()
        XCTAssertEqual(stream.length, 0)
        XCTAssertEqual(stream.position, 0)
        XCTAssertEqual(stream.readTimeout, 0)
        XCTAssertEqual(stream.writeTimeout, 0)
        XCTAssertEqual(stream.canRead, false)
        XCTAssertEqual(stream.canSeek, false)
        XCTAssertEqual(stream.canTimeout, false)
        XCTAssertEqual(stream.canWrite, false)
    }

    func testMemoryStreamCopyTo() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        let destination = MemoryStream()
        stream.copyTo(destination: destination)

        let copiedData = destination.toData()

        XCTAssertEqual(destination.length, 10)
        XCTAssertEqual(destination.position, 10)
        XCTAssertEqual(destination.readTimeout, 0)
        XCTAssertEqual(destination.writeTimeout, 0)
        XCTAssertEqual(copiedData, bytes)
    }

    func testMemoryStreamCopyToAsync() async throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        let destination = MemoryStream()
        await stream.copyToAsync(destination: destination)

        let copiedData = destination.toData()

        XCTAssertEqual(destination.length, 10)
        XCTAssertEqual(destination.position, 10)
        XCTAssertEqual(destination.readTimeout, 0)
        XCTAssertEqual(destination.writeTimeout, 0)
        XCTAssertEqual(copiedData, bytes)
    }

    func testMemoryStreamRead() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        var buffer = Data(count: 5)
        let read = stream.read(buffer: &buffer, offset: 0, count: 5)
        XCTAssertEqual(read, 5)
        XCTAssertEqual(stream.position, 5)
        XCTAssertEqual(buffer, Data([0x00, 0x01, 0x02, 0x03, 0x04]))
    }

    func testMemoryStreamReadAsync() async throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        var buffer = Data(count: 5)
        let read = await stream.readAsync(buffer: &buffer, offset: 0, count: 5)
        XCTAssertEqual(read, 5)
        XCTAssertEqual(stream.position, 5)
        XCTAssertEqual(buffer, Data([0x00, 0x01, 0x02, 0x03, 0x04]))
    }

    func testMemoryStreamReadByte() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        let byte = stream.readByte()
        XCTAssertEqual(byte, 0x00)
        XCTAssertEqual(stream.position, 1)
    }

    func testMemoryStreamSeek() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        let position = stream.seek(offset: 5, origin: .begin)
        XCTAssertEqual(position, 5)
        XCTAssertEqual(stream.position, 5)
    }

    func testMemoryStreamSetLengthTurncate() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        stream.setLength(length: 5)
        XCTAssertEqual(stream.length, 5)
        XCTAssertEqual(stream.position, 0)
        XCTAssertEqual(stream.toData(), Data([0x00, 0x01, 0x02, 0x03, 0x04]))
    }

    func testMemoryStreamSetLengthExtend() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        stream.setLength(length: 15)
        XCTAssertEqual(stream.length, 15)
        XCTAssertEqual(stream.position, 0)
        XCTAssertEqual(stream.toData(), Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00]))
    }

    func testMemoryStreamWrite() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        _ = stream.seek(offset: 0, origin: .end)
        let buffer = Data([0x0A, 0x0B, 0x0C, 0x0D, 0x0E])
        stream.write(buffer: buffer, offset: 0, count: 5)
        XCTAssertEqual(stream.length, 15)
        XCTAssertEqual(stream.position, 15)
        XCTAssertEqual(stream.toData(), Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E]))

        _ = stream.seek(offset: 0, origin: .begin)
        let buffer2 = Data([0x0F, 0x10, 0x11, 0x12, 0x13])
        stream.write(buffer: buffer2, offset: 0, count: 5)
        XCTAssertEqual(stream.length, 15)
        XCTAssertEqual(stream.position, 5)
        XCTAssertEqual(stream.toData(), Data([0x0F, 0x10, 0x11, 0x12, 0x13, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E]))
    }

    func testMemoryStreamWriteAsync() async throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        _ = stream.seek(offset: 0, origin: .end)
        let buffer = Data([0x0A, 0x0B, 0x0C, 0x0D, 0x0E])
        await stream.writeAsync(buffer: buffer, offset: 0, count: 5)
        XCTAssertEqual(stream.length, 15)
        XCTAssertEqual(stream.position, 15)
        XCTAssertEqual(stream.toData(), Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E]))

        _ = stream.seek(offset: 0, origin: .begin)
        let buffer2 = Data([0x0F, 0x10, 0x11, 0x12, 0x13])
        await stream.writeAsync(buffer: buffer2, offset: 0, count: 5)
        XCTAssertEqual(stream.length, 15)
        XCTAssertEqual(stream.position, 5)
        XCTAssertEqual(stream.toData(), Data([0x0F, 0x10, 0x11, 0x12, 0x13, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E]))
    }

    func testMemoryStreamWriteByte() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        _ = stream.seek(offset: 0, origin: .end)
        stream.writeByte(byte: 0x0A)
        XCTAssertEqual(stream.length, 11)
        XCTAssertEqual(stream.position, 11)
        XCTAssertEqual(stream.toData(), Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A]))
    }

    func testMemoryStreamSetPosition() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        stream.position = 5
        XCTAssertEqual(stream.position, 5)
    }

    func testMemoryStreamSetPositionAndRead() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        stream.position = 5
        XCTAssertEqual(stream.position, 5)
        var buffer = Data(count: 5)
        let read = stream.read(buffer: &buffer, offset: 0, count: 5)
        XCTAssertEqual(read, 5)
        XCTAssertEqual(stream.position, 10)
        XCTAssertEqual(buffer, Data([0x05, 0x06, 0x07, 0x08, 0x09]))
    }

    func testMemoryStreamSetPositionAndWrite() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        stream.position = 5
        XCTAssertEqual(stream.position, 5)
        let buffer = Data([0x0A, 0x0B, 0x0C, 0x0D, 0x0E])
        stream.write(buffer: buffer, offset: 0, count: 5)
        XCTAssertEqual(stream.length, 10)
        XCTAssertEqual(stream.position, 10)
        XCTAssertEqual(stream.toData(), Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E]))
    }

    func testMemoryStreamToArray() throws {
        let bytes = Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09])
        let stream = MemoryStream(bytes: bytes)
        let array = stream.toArray()
        XCTAssertEqual(array, Array(bytes))
    }
}