import Foundation
import XCTest
@testable import SwiftIO

class FileStreamTests: XCTestCase {
    func testFileStream() {
        let file = FileStream(path: "test.txt", mode: .createNew)
        let bytes = [UInt8]("Hello, world!".utf8)
        file.write(buffer: Data(bytes), offset: 0, count: Int32(bytes.count))
        file.close()
        let file2 = FileStream(path: "test.txt", mode: .open)
        var buffer = Data(count: 1024)
        let bytesRead = file2.read(buffer: &buffer, offset: 0, count: 1024)
        file2.close()
        XCTAssertEqual(bytesRead, Int32(bytes.count))
        XCTAssertEqual(buffer[0..<bytesRead], Data(bytes))

        // cleanup
        try! FileManager.default.removeItem(atPath: "test.txt")
    }

    func testFileStreamFromFileHandle() {
        let file = FileStream(path: "test.txt", mode: .createNew)
        let bytes = [UInt8]("Hello, world!".utf8)
        file.write(buffer: Data(bytes), offset: 0, count: Int32(bytes.count))
        file.close()
        let file2 = FileStream(fileHandle: FileHandle(forUpdatingAtPath: "test.txt")!)
        var buffer = Data(count: 1024)
        let bytesRead = file2.read(buffer: &buffer, offset: 0, count: 1024)
        file2.close()
        XCTAssertEqual(bytesRead, Int32(bytes.count))
        XCTAssertEqual(buffer[0..<bytesRead], Data(bytes))

        // cleanup
        try! FileManager.default.removeItem(atPath: "test.txt")
    }
    
    func testFileStreamSetLength() {
        let file = FileStream(path: "test.txt", mode: .createNew)
        let bytes = [UInt8]("Hello, world!".utf8)
        file.write(buffer: Data(bytes), offset: 0, count: Int32(bytes.count))
        file.setLength(length: 5)
        file.close()
        let file2 = FileStream(path: "test.txt", mode: .open)
        var buffer = Data(count: 1024)
        let bytesRead = file2.read(buffer: &buffer, offset: 0, count: 1024)
        file2.close()
        XCTAssertEqual(bytesRead, 5)
        XCTAssertEqual(buffer[0..<bytesRead], Data(bytes[0..<5]))

        // cleanup
        try! FileManager.default.removeItem(atPath: "test.txt")
    }

    func testFileStreamSeek() {
        let file = FileStream(path: "test.txt", mode: .createNew)
        let bytes = [UInt8]("Hello, world!".utf8)
        file.write(buffer: Data(bytes), offset: 0, count: Int32(bytes.count))
        file.close()
        let file2 = FileStream(path: "test.txt", mode: .open)
        var buffer = Data(count: 1024)
        let position = file2.seek(offset: 7, origin: .begin)
        let bytesRead = file2.read(buffer: &buffer, offset: 0, count: 1024)
        file2.close()
        XCTAssertEqual(position, 7)
        XCTAssertEqual(bytesRead, Int32(bytes.count - 7))
        XCTAssertEqual(buffer[0..<bytesRead], Data(bytes[7..<bytes.count]))

        // cleanup
        try! FileManager.default.removeItem(atPath: "test.txt")
    }
}