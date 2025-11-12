import XCTest
@testable import SwiftIO

final class StreamResultCallbackTests: XCTestCase {
    
    // MARK: - MemoryStream Result Callback Tests
    
    func testMemoryStreamReadByteResultCallback() {
        let expectation = XCTestExpectation(description: "Read byte callback")
        let stream = MemoryStream(bytes: [0x42, 0x43, 0x44])
        
        stream.readByte { result in
            switch result {
            case .success(let byte):
                XCTAssertEqual(byte, 0x42)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMemoryStreamReadByteResultCallbackEndOfStream() {
        let expectation = XCTestExpectation(description: "Read byte at end of stream")
        let stream = MemoryStream(bytes: [])
        
        stream.readByte { result in
            switch result {
            case .success:
                XCTFail("Should fail with end of stream")
            case .failure(let error):
                if case .endOfStream = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error type")
                }
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMemoryStreamReadResultCallback() {
        let expectation = XCTestExpectation(description: "Read callback")
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0x05])
        var buffer = Data(count: 3)
        
        stream.read(buffer: &buffer, offset: 0, count: 3) { result in
            switch result {
            case .success(let bytesRead):
                XCTAssertEqual(bytesRead, 3)
                XCTAssertEqual(buffer[0], 0x01)
                XCTAssertEqual(buffer[1], 0x02)
                XCTAssertEqual(buffer[2], 0x03)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMemoryStreamWriteByteResultCallback() {
        let expectation = XCTestExpectation(description: "Write byte callback")
        let stream = MemoryStream()
        
        stream.writeByte(byte: 0xAA) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 1)
                XCTAssertEqual(stream.toData()[0], 0xAA)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMemoryStreamWriteResultCallback() {
        let expectation = XCTestExpectation(description: "Write callback")
        let stream = MemoryStream()
        let data = Data([0x01, 0x02, 0x03])
        
        stream.write(buffer: data, offset: 0, count: 3) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 3)
                XCTAssertEqual(stream.toData(), data)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMemoryStreamSeekResultCallback() {
        let expectation = XCTestExpectation(description: "Seek callback")
        let stream = MemoryStream(bytes: [0x00, 0x01, 0x02, 0x03, 0x04])
        
        stream.seek(offset: 3, origin: .begin) { result in
            switch result {
            case .success(let position):
                XCTAssertEqual(position, 3)
                XCTAssertEqual(stream.position, 3)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMemoryStreamSetLengthResultCallback() {
        let expectation = XCTestExpectation(description: "Set length callback")
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03])
        
        stream.setLength(length: 5) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 5)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMemoryStreamCopyToResultCallback() {
        let expectation = XCTestExpectation(description: "Copy to callback")
        let source = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0x05])
        let destination = MemoryStream()
        
        source.copyTo(destination: destination) { result in
            switch result {
            case .success:
                XCTAssertEqual(destination.length, 5)
                XCTAssertEqual(destination.toData(), source.toData())
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMemoryStreamFlushResultCallback() {
        let expectation = XCTestExpectation(description: "Flush callback")
        let stream = MemoryStream()
        
        stream.flush { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMemoryStreamClosedStreamError() {
        let expectation = XCTestExpectation(description: "Closed stream error")
        let stream = MemoryStream(bytes: [0x01, 0x02])
        stream.close()
        
        stream.readByte { result in
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
    
    func testMemoryStreamInvalidOffsetError() {
        let expectation = XCTestExpectation(description: "Invalid offset error")
        let stream = MemoryStream(bytes: [0x01, 0x02])
        var buffer = Data(count: 2)
        
        stream.read(buffer: &buffer, offset: -1, count: 1) { result in
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
    
    // MARK: - FileStream Result Callback Tests
    
    func testFileStreamReadByteResultCallback() throws {
        let expectation = XCTestExpectation(description: "File stream read byte callback")
        let file = try FileStream(path: "test_result.txt", mode: .createNew)
        try file.write(buffer: Data([0x42]), offset: 0, count: 1)
        file.close()
        
        let file2 = try FileStream(path: "test_result.txt", mode: .open)
        file2.readByte { result in
            switch result {
            case .success(let byte):
                XCTAssertEqual(byte, 0x42)
                file2.close()
                try? FileManager.default.removeItem(atPath: "test_result.txt")
                expectation.fulfill()
            case .failure:
                file2.close()
                try? FileManager.default.removeItem(atPath: "test_result.txt")
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFileStreamWriteResultCallback() throws {
        let expectation = XCTestExpectation(description: "File stream write callback")
        let file = try FileStream(path: "test_result2.txt", mode: .createNew)
        let data = Data([0x01, 0x02, 0x03])
        
        file.write(buffer: data, offset: 0, count: 3) { result in
            switch result {
            case .success:
                file.close()
                let file2 = try? FileStream(path: "test_result2.txt", mode: .open)
                var buffer = Data(count: 3)
                _ = try? file2?.read(buffer: &buffer, offset: 0, count: 3)
                XCTAssertEqual(buffer, data)
                file2?.close()
                try? FileManager.default.removeItem(atPath: "test_result2.txt")
                expectation.fulfill()
            case .failure:
                file.close()
                try? FileManager.default.removeItem(atPath: "test_result2.txt")
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Async Result Callback Tests
    
    func testMemoryStreamReadAsyncResultCallback() {
        let expectation = XCTestExpectation(description: "Read async callback")
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0x05])
        var buffer = Data(count: 3)
        
        stream.readAsync(buffer: &buffer, offset: 0, count: 3) { result in
            switch result {
            case .success(let bytesRead):
                XCTAssertEqual(bytesRead, 3)
                XCTAssertEqual(buffer[0], 0x01)
                XCTAssertEqual(buffer[1], 0x02)
                XCTAssertEqual(buffer[2], 0x03)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testMemoryStreamWriteAsyncResultCallback() {
        let expectation = XCTestExpectation(description: "Write async callback")
        let stream = MemoryStream()
        let data = Data([0x01, 0x02, 0x03])
        
        stream.writeAsync(buffer: data, offset: 0, count: 3) { result in
            switch result {
            case .success:
                XCTAssertEqual(stream.length, 3)
                XCTAssertEqual(stream.toData(), data)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testMemoryStreamCopyToAsyncResultCallback() {
        let expectation = XCTestExpectation(description: "Copy to async callback")
        let source = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0x05])
        let destination = MemoryStream()
        
        source.copyToAsync(destination: destination) { result in
            switch result {
            case .success:
                XCTAssertEqual(destination.length, 5)
                XCTAssertEqual(destination.toData(), source.toData())
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testMemoryStreamFlushAsyncResultCallback() {
        let expectation = XCTestExpectation(description: "Flush async callback")
        let stream = MemoryStream()
        
        stream.flushAsync { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}

