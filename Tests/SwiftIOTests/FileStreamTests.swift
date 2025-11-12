import Foundation
import XCTest
@testable import SwiftIO

class FileStreamTests: XCTestCase {
    func testFileStream() throws {
        let file = try FileStream(path: "test.txt", mode: .createNew)
        let bytes = [UInt8]("Hello, world!".utf8)
        try file.write(buffer: Data(bytes), offset: 0, count: bytes.count)
        file.close()
        let file2 = try FileStream(path: "test.txt", mode: .open)
        var buffer = Data(count: 1024)
        let bytesRead = try file2.read(buffer: &buffer, offset: 0, count: 1024)
        file2.close()
        XCTAssertEqual(bytesRead, bytes.count)
        XCTAssertEqual(buffer[0..<Int(bytesRead)], Data(bytes))

        // cleanup
        try FileManager.default.removeItem(atPath: "test.txt")
    }

    func testFileStreamFromFileHandle() throws {
        let file = try FileStream(path: "test.txt", mode: .createNew)
        let bytes = [UInt8]("Hello, world!".utf8)
        try file.write(buffer: Data(bytes), offset: 0, count: bytes.count)
        file.close()
        guard let fileHandle = FileHandle(forUpdatingAtPath: "test.txt") else {
            XCTFail("Failed to open file handle")
            return
        }
        let file2 = FileStream(fileHandle: fileHandle)
        var buffer = Data(count: 1024)
        let bytesRead = try file2.read(buffer: &buffer, offset: 0, count: 1024)
        file2.close()
        XCTAssertEqual(bytesRead, bytes.count)
        XCTAssertEqual(buffer[0..<Int(bytesRead)], Data(bytes))

        // cleanup
        try FileManager.default.removeItem(atPath: "test.txt")
    }
    
    func testFileStreamSetLength() throws {
        let file = try FileStream(path: "test.txt", mode: .createNew)
        let bytes = [UInt8]("Hello, world!".utf8)
        try file.write(buffer: Data(bytes), offset: 0, count: bytes.count)
        try file.setLength(length: 5)
        file.close()
        let file2 = try FileStream(path: "test.txt", mode: .open)
        var buffer = Data(count: 1024)
        let bytesRead = try file2.read(buffer: &buffer, offset: 0, count: 1024)
        file2.close()
        XCTAssertEqual(bytesRead, 5)
        XCTAssertEqual(buffer[0..<Int(bytesRead)], Data(bytes[0..<5]))

        // cleanup
        try FileManager.default.removeItem(atPath: "test.txt")
    }

    func testFileStreamSeek() throws {
        let file = try FileStream(path: "test.txt", mode: .createNew)
        let bytes = [UInt8]("Hello, world!".utf8)
        try file.write(buffer: Data(bytes), offset: 0, count: bytes.count)
        file.close()
        let file2 = try FileStream(path: "test.txt", mode: .open)
        var buffer = Data(count: 1024)
        let position = try file2.seek(offset: 7, origin: .begin)
        let bytesRead = try file2.read(buffer: &buffer, offset: 0, count: 1024)
        file2.close()
        XCTAssertEqual(position, 7)
        XCTAssertEqual(bytesRead, bytes.count - 7)
        XCTAssertEqual(buffer[0..<Int(bytesRead)], Data(bytes[7..<bytes.count]))

        // cleanup
        try FileManager.default.removeItem(atPath: "test.txt")
    }

    func testFileStreamCopyTo() throws {
        let file = try FileStream(path: "test.txt", mode: .createNew)
        let bytes = [UInt8]("Hello, world!".utf8)
        try file.write(buffer: Data(bytes), offset: 0, count: bytes.count)
        file.close()
        let file2 = try FileStream(path: "test.txt", mode: .open)
        let file3 = try FileStream(path: "test2.txt", mode: .createNew)
        try file2.copyTo(destination: file3)
        file2.close()
        file3.close()
        let file4 = try FileStream(path: "test2.txt", mode: .open)
        var buffer = Data(count: 1024)
        let bytesRead = try file4.read(buffer: &buffer, offset: 0, count: 1024)
        file4.close()
        XCTAssertEqual(bytesRead, bytes.count)
        XCTAssertEqual(buffer[0..<Int(bytesRead)], Data(bytes))

        // cleanup
        try FileManager.default.removeItem(atPath: "test.txt")
        try FileManager.default.removeItem(atPath: "test2.txt")
    }
}