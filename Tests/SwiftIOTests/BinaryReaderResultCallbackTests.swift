import XCTest
@testable import SwiftIO

final class BinaryReaderResultCallbackTests: XCTestCase {
    
    func testReadByteResultCallback() {
        let expectation = XCTestExpectation(description: "Read byte callback")
        let stream = MemoryStream(bytes: [0x42])
        let reader = BinaryReader(stream)
        
        reader.readByte { result in
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
    
    func testReadBytesResultCallback() {
        let expectation = XCTestExpectation(description: "Read bytes callback")
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04])
        let reader = BinaryReader(stream)
        
        reader.readBytes(4) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.count, 4)
                XCTAssertEqual(data[0], 0x01)
                XCTAssertEqual(data[1], 0x02)
                XCTAssertEqual(data[2], 0x03)
                XCTAssertEqual(data[3], 0x04)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadBytesEndOfStream() {
        let expectation = XCTestExpectation(description: "Read bytes end of stream")
        let stream = MemoryStream(bytes: [])
        let reader = BinaryReader(stream)
        
        reader.readBytes(1) { result in
            switch result {
            case .success:
                XCTFail("Should fail with end of stream")
            case .failure(let error):
                if case .endOfStream = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error type: \(error)")
                }
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadInt16ResultCallback() {
        let expectation = XCTestExpectation(description: "Read Int16 callback")
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04])
        let reader = BinaryReader(stream)
        
        reader.readInt16 { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 0x0201)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadInt32ResultCallback() {
        let expectation = XCTestExpectation(description: "Read Int32 callback")
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04])
        let reader = BinaryReader(stream)
        
        reader.readInt32 { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 0x04030201)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadInt64ResultCallback() {
        let expectation = XCTestExpectation(description: "Read Int64 callback")
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08])
        let reader = BinaryReader(stream)
        
        reader.readInt64 { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 0x0807060504030201)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadUInt16ResultCallback() {
        let expectation = XCTestExpectation(description: "Read UInt16 callback")
        let stream = MemoryStream(bytes: [0x01, 0x02])
        let reader = BinaryReader(stream)
        
        reader.readUInt16 { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 0x0201)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadUInt32ResultCallback() {
        let expectation = XCTestExpectation(description: "Read UInt32 callback")
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04])
        let reader = BinaryReader(stream)
        
        reader.readUInt32 { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 0x04030201)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadUInt64ResultCallback() {
        let expectation = XCTestExpectation(description: "Read UInt64 callback")
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08])
        let reader = BinaryReader(stream)
        
        reader.readUInt64 { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 0x0807060504030201)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadCharResultCallback() {
        let expectation = XCTestExpectation(description: "Read char callback")
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63])
        let reader = BinaryReader(stream)
        
        reader.readChar { result in
            switch result {
            case .success(let char):
                XCTAssertEqual(char, "a")
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadCharWithEncodingResultCallback() {
        let expectation = XCTestExpectation(description: "Read char with encoding callback")
        let stream = MemoryStream(bytes: [0x61])
        let reader = BinaryReader(stream, encoding: .utf8)
        
        reader.readChar(encoding: .utf8) { result in
            switch result {
            case .success(let char):
                XCTAssertEqual(char, "a")
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadCharsResultCallback() {
        let expectation = XCTestExpectation(description: "Read chars callback")
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63])
        let reader = BinaryReader(stream)
        
        reader.readChars(3) { result in
            switch result {
            case .success(let chars):
                XCTAssertEqual(chars.count, 3)
                XCTAssertEqual(chars[0], "a")
                XCTAssertEqual(chars[1], "b")
                XCTAssertEqual(chars[2], "c")
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadStringResultCallback() {
        let expectation = XCTestExpectation(description: "Read string callback")
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63, 0x64, 0x65])
        let reader = BinaryReader(stream)
        
        reader.readString(5) { result in
            switch result {
            case .success(let str):
                XCTAssertEqual(str, "abcde")
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadStringWithEncodingResultCallback() {
        let expectation = XCTestExpectation(description: "Read string with encoding callback")
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63])
        let reader = BinaryReader(stream)
        
        reader.readString(3, encoding: .utf8) { result in
            switch result {
            case .success(let str):
                XCTAssertEqual(str, "abc")
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadStringWithFormatResultCallback() {
        let expectation = XCTestExpectation(description: "Read string with format callback")
        let stream = MemoryStream(bytes: [0x61, 0x62, 0x63, 0x00])
        let reader = BinaryReader(stream)
        
        reader.readString(format: .zeroTerminated) { result in
            switch result {
            case .success(let str):
                XCTAssertEqual(str, "abc")
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadStringWithBytePrefixResultCallback() {
        let expectation = XCTestExpectation(description: "Read string with byte prefix callback")
        let stream = MemoryStream(bytes: [0x03, 0x61, 0x62, 0x63])
        let reader = BinaryReader(stream)
        
        reader.readString(format: .bytePrefixLength) { result in
            switch result {
            case .success(let str):
                XCTAssertEqual(str, "abc")
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadToEndResultCallback() {
        let expectation = XCTestExpectation(description: "Read to end callback")
        let stream = MemoryStream(bytes: [0x01, 0x02, 0x03, 0x04, 0x05])
        let reader = BinaryReader(stream)
        
        reader.readToEnd { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.count, 5)
                XCTAssertEqual(data[0], 0x01)
                XCTAssertEqual(data[4], 0x05)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadInt16BigEndianResultCallback() {
        let expectation = XCTestExpectation(description: "Read Int16 big endian callback")
        let stream = MemoryStream(bytes: [0x01, 0x02])
        let reader = BinaryReader(stream, endianess: .big)
        
        reader.readInt16 { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 0x0102)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

