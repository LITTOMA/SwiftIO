import XCTest
@testable import SwiftIO

final class BinaryWriterResultCallbackTests: XCTestCase {
    
    func testWriteByteResultCallback() {
        let expectation = XCTestExpectation(description: "Write byte callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeByte(0x42) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 1)
                XCTAssertEqual(stream.toData()[0], 0x42)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteBytesResultCallback() {
        let expectation = XCTestExpectation(description: "Write bytes callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        let bytes = Data([0x01, 0x02, 0x03])
        
        writer.writeBytes(bytes) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 3)
                XCTAssertEqual(stream.toData(), bytes)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteInt16ResultCallback() {
        let expectation = XCTestExpectation(description: "Write Int16 callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeInt16(0x0201) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 2)
                let reader = BinaryReader(stream)
                do {
                    stream.position = 0
                    let value = try reader.readInt16()
                    XCTAssertEqual(value, 0x0201)
                } catch {
                    XCTFail("Failed to read back value")
                }
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteInt32ResultCallback() {
        let expectation = XCTestExpectation(description: "Write Int32 callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeInt32(0x04030201) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 4)
                let reader = BinaryReader(stream)
                do {
                    stream.position = 0
                    let value = try reader.readInt32()
                    XCTAssertEqual(value, 0x04030201)
                } catch {
                    XCTFail("Failed to read back value")
                }
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteInt64ResultCallback() {
        let expectation = XCTestExpectation(description: "Write Int64 callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeInt64(0x0807060504030201) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 8)
                let reader = BinaryReader(stream)
                do {
                    stream.position = 0
                    let value = try reader.readInt64()
                    XCTAssertEqual(value, 0x0807060504030201)
                } catch {
                    XCTFail("Failed to read back value")
                }
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteUInt16ResultCallback() {
        let expectation = XCTestExpectation(description: "Write UInt16 callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeUInt16(0x0201) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 2)
                let reader = BinaryReader(stream)
                do {
                    stream.position = 0
                    let value = try reader.readUInt16()
                    XCTAssertEqual(value, 0x0201)
                } catch {
                    XCTFail("Failed to read back value")
                }
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteUInt32ResultCallback() {
        let expectation = XCTestExpectation(description: "Write UInt32 callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeUInt32(0x04030201) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 4)
                let reader = BinaryReader(stream)
                do {
                    stream.position = 0
                    let value = try reader.readUInt32()
                    XCTAssertEqual(value, 0x04030201)
                } catch {
                    XCTFail("Failed to read back value")
                }
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteUInt64ResultCallback() {
        let expectation = XCTestExpectation(description: "Write UInt64 callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeUInt64(0x0807060504030201) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 8)
                let reader = BinaryReader(stream)
                do {
                    stream.position = 0
                    let value = try reader.readUInt64()
                    XCTAssertEqual(value, 0x0807060504030201)
                } catch {
                    XCTFail("Failed to read back value")
                }
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteFloatResultCallback() {
        let expectation = XCTestExpectation(description: "Write Float callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        let value: Float = 3.14
        
        writer.writeFloat(value) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 4)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteDoubleResultCallback() {
        let expectation = XCTestExpectation(description: "Write Double callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        let value: Double = 3.14159
        
        writer.writeDouble(value) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 8)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteCharResultCallback() {
        let expectation = XCTestExpectation(description: "Write char callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeChar("a") { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 1)
                XCTAssertEqual(stream.toData()[0], 0x61)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteCharWithEncodingResultCallback() {
        let expectation = XCTestExpectation(description: "Write char with encoding callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream, encoding: .utf8)
        
        writer.writeChar("a", encoding: .utf8) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 1)
                XCTAssertEqual(stream.toData()[0], 0x61)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteCharsResultCallback() {
        let expectation = XCTestExpectation(description: "Write chars callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeChars(["a", "b", "c"]) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 3)
                XCTAssertEqual(stream.toData(), Data([0x61, 0x62, 0x63]))
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteStringResultCallback() {
        let expectation = XCTestExpectation(description: "Write string callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeString("Hello") { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 5)
                XCTAssertEqual(stream.toData(), Data("Hello".utf8))
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteStringWithEncodingResultCallback() {
        let expectation = XCTestExpectation(description: "Write string with encoding callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeString("Hello", encoding: .utf8) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 5)
                XCTAssertEqual(stream.toData(), Data("Hello".utf8))
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteStringWithFormatResultCallback() {
        let expectation = XCTestExpectation(description: "Write string with format callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeString("abc", format: .zeroTerminated) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 4) // "abc" + null terminator
                XCTAssertEqual(stream.toData()[3], 0x00)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteStringWithBytePrefixResultCallback() {
        let expectation = XCTestExpectation(description: "Write string with byte prefix callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeString("abc", format: .bytePrefixLength) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 4) // 1 byte prefix + 3 bytes
                XCTAssertEqual(stream.toData()[0], 0x03) // length prefix
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFlushResultCallback() {
        let expectation = XCTestExpectation(description: "Flush callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.flush { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteToClosedStreamError() {
        let expectation = XCTestExpectation(description: "Write to closed stream error")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        writer.close()
        
        writer.writeByte(0x42) { result in
            switch result {
            case .success:
                XCTFail("Should fail with stream closed")
            case .failure(let error):
                if case .streamClosed = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error type: \(error)")
                }
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMultipleWritesResultCallback() {
        let expectation = XCTestExpectation(description: "Multiple writes callback")
        expectation.expectedFulfillmentCount = 3
        
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.writeInt32(12345) { result in
            if case .success = result {
                expectation.fulfill()
            }
        }
        
        writer.writeString("Hello") { result in
            if case .success = result {
                expectation.fulfill()
            }
        }
        
        writer.writeDouble(3.14) { result in
            if case .success = result {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(stream.length, 4 + 5 + 8) // Int32 + String + Double
    }
    
    func testFlushAsyncResultCallback() {
        let expectation = XCTestExpectation(description: "Flush async callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        writer.flushAsync { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testWriteInt16BigEndianResultCallback() {
        let expectation = XCTestExpectation(description: "Write Int16 big endian callback")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream, endianess: .big)
        
        writer.writeInt16(0x0102) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 2)
                let reader = BinaryReader(stream, endianess: .big)
                do {
                    stream.position = 0
                    let value = try reader.readInt16()
                    XCTAssertEqual(value, 0x0102)
                } catch {
                    XCTFail("Failed to read back value")
                }
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWriteStringTooLongForBytePrefixError() {
        let expectation = XCTestExpectation(description: "Write string too long for byte prefix error")
        let stream = MemoryStream()
        let writer = BinaryWriter(stream)
        
        // Create a string that will be longer than 255 bytes when encoded
        let longString = String(repeating: "a", count: 300)
        
        writer.writeString(longString, format: .bytePrefixLength) { result in
            switch result {
            case .success:
                XCTFail("Should fail with invalid operation")
            case .failure(let error):
                if case .invalidOperation = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error type: \(error)")
                }
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

