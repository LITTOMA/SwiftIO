import Foundation

/// A stream for reading from and writing to files, similar to .NET's FileStream class.
///
/// FileStream provides a Stream for a file, supporting both synchronous and asynchronous read and write operations.
/// It uses the underlying FileHandle for file operations and provides a familiar interface for .NET developers.
public class FileStream: Stream {
    /// Indicates whether the stream supports reading.
    public var canRead: Bool {
        return !isClosed
    }
    
    /// Indicates whether the stream supports seeking.
    public var canSeek: Bool {
        return !isClosed
    }
    
    /// Indicates whether the stream can time out.
    public var canTimeout: Bool {
        return !isClosed
    }
    
    /// Indicates whether the stream supports writing.
    public var canWrite: Bool {
        return !isClosed
    }
    
    private var cachedLength: Int?
    
    /// Gets the length in bytes of the stream.
    ///
    /// The length is cached for performance. The cache is invalidated when the file is written to or truncated.
    public var length: Int {
        if let cached = cachedLength {
            return cached
        }
        let currentOffset = self.position
        let length = Int(fileHandle.seekToEndOfFile())
        self.position = currentOffset
        cachedLength = length
        return length
    }
    
    /// Gets or sets the position within the stream.
    public var position: Int {
        get {
            return Int(fileHandle.offsetInFile)
        }
        set {
            fileHandle.seek(toFileOffset: UInt64(newValue))
        }
    }
    
    /// Gets or sets a value that determines how long the stream will attempt to read before timing out.
    public var readTimeout: Int
    
    /// Gets or sets a value that determines how long the stream will attempt to write before timing out.
    public var writeTimeout: Int

    private var fileHandle: FileHandle
    private var isClosed: Bool = false
    
    deinit {
        if !isClosed {
            close()
        }
    }

    /// Initializes a new instance of the FileStream class for the specified file path and mode.
    /// - Parameters:
    ///   - path: A relative or absolute path for the file that the FileStream will encapsulate.
    ///   - mode: A constant that determines how to open or create the file.
    /// - Throws: `SwiftIOError.fileNotFound` if the file doesn't exist and mode requires it, or other `SwiftIOError` if an I/O error occurs.
    public init(path: String, mode: FileMode) throws {
        if mode == .createNew {
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        } else if mode == .create {
            if !FileManager.default.fileExists(atPath: path) {
                FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            }
        } else if mode == .open {
            if !FileManager.default.fileExists(atPath: path) {
                throw SwiftIOError.fileNotFound(path)
            }
        } else if mode == .openOrCreate {
            if !FileManager.default.fileExists(atPath: path) {
                FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            }
        } else if mode == .truncate {
            if !FileManager.default.fileExists(atPath: path) {
                FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            } else {
                let fileHandle = FileHandle(forUpdatingAtPath: path)!
                fileHandle.truncateFile(atOffset: 0)
                fileHandle.closeFile()
            }
        } else if mode == .append {
            if !FileManager.default.fileExists(atPath: path) {
                FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            }
        }

        guard let fileHandle = FileHandle(forUpdatingAtPath: path) else {
            throw SwiftIOError.fileNotFound(path)
        }
        self.fileHandle = fileHandle
        self.readTimeout = 0
        self.writeTimeout = 0

        switch mode {
        case .append:
            self.fileHandle.seekToEndOfFile()
        case .create:
            self.fileHandle.truncateFile(atOffset: 0)
        case .createNew:
            self.fileHandle.truncateFile(atOffset: 0)
        case .open:
            break
        case .openOrCreate:
            break
        case .truncate:
            self.fileHandle.truncateFile(atOffset: 0)
        }
    }

    /// Initializes a new instance of the FileStream class for the specified file handle.
    /// - Parameter fileHandle: The FileHandle object to use for file operations.
    init(fileHandle: FileHandle) {
        self.fileHandle = fileHandle
        self.readTimeout = 0
        self.writeTimeout = 0
    }

    public func close() {
        if !isClosed {
            self.fileHandle.closeFile()
            self.isClosed = true
            cachedLength = nil
        }
    }

    public func copyTo(destination: Stream) throws {
        try self.copyTo(destination: destination, bufferSize: 4096)
    }

    public func copyTo(destination: Stream, bufferSize: Int) throws {
        var buffer = Data(count: bufferSize)
        self.position = 0

        while true {
            let bytesRead = try self.read(buffer: &buffer, offset: 0, count: bufferSize)

            if bytesRead == 0 {
                break
            }

            try destination.write(buffer: buffer, offset: 0, count: bytesRead)
        }
    }

    public func copyToAsync(destination: Stream) async throws {
        try await self.copyToAsync(destination: destination, bufferSize: 4096)
    }

    public func copyToAsync(destination: Stream, bufferSize: Int) async throws {
        var buffer = Data(count: bufferSize)
        self.position = 0

        while true {
            let bytesRead = try await self.readAsync(buffer: &buffer, offset: 0, count: bufferSize)

            if bytesRead == 0 {
                break
            }

            try await destination.writeAsync(buffer: buffer, offset: 0, count: bytesRead)
        }
    }

    public func flush() throws {
        self.fileHandle.synchronizeFile()
    }

    public func flushAsync() async throws {
        self.fileHandle.synchronizeFile()
    }

    public func read(buffer: inout Data, offset: Int, count: Int) throws -> Int {
        if offset < 0 || count < 0 || offset + count > buffer.count {
            throw SwiftIOError.invalidOperation("Invalid offset or count: offset=\(offset), count=\(count), buffer.count=\(buffer.count)")
        }
        if isClosed {
            throw SwiftIOError.streamClosed
        }
        let data = self.fileHandle.readData(ofLength: count)
        if data.count == 0 {
            return 0
        }
        let actualCount = min(data.count, buffer.count - offset)
        buffer.replaceSubrange(offset..<offset + actualCount, with: data.prefix(actualCount))
        return actualCount
    }

    public func readByte() throws -> UInt8 {
        if isClosed {
            throw SwiftIOError.streamClosed
        }
        let data = self.fileHandle.readData(ofLength: 1)
        if data.count == 0 {
            throw SwiftIOError.endOfStream
        }
        return data[0]
    }

    public func readAsync(buffer: inout Data, offset: Int, count: Int) async throws -> Int {
        if offset < 0 || count < 0 || offset + count > buffer.count {
            throw SwiftIOError.invalidOperation("Invalid offset or count: offset=\(offset), count=\(count), buffer.count=\(buffer.count)")
        }
        if isClosed {
            throw SwiftIOError.streamClosed
        }
        let data = self.fileHandle.readData(ofLength: count)
        if data.count == 0 {
            return 0
        }
        let actualCount = min(data.count, buffer.count - offset)
        buffer.replaceSubrange(offset..<offset + actualCount, with: data.prefix(actualCount))
        return actualCount
    }

    public func seek(offset: Int, origin: SeekOrigin) throws -> Int {
        if isClosed {
            throw SwiftIOError.streamClosed
        }
        switch origin {
        case .begin:
            self.position = offset
        case .current:
            self.position += offset
        case .end:
            self.position = self.length + offset
        }

        return self.position
    }

    public func setLength(length: Int) throws {
        if isClosed {
            throw SwiftIOError.streamClosed
        }
        if length < 0 {
            throw SwiftIOError.invalidOperation("Invalid length: \(length)")
        }
        self.fileHandle.truncateFile(atOffset: UInt64(length))
        cachedLength = length
    }

    public func write(buffer: Data, offset: Int, count: Int) throws {
        if offset < 0 || count < 0 || offset + count > buffer.count {
            throw SwiftIOError.invalidOperation("Invalid offset or count: offset=\(offset), count=\(count), buffer.count=\(buffer.count)")
        }
        if isClosed {
            throw SwiftIOError.streamClosed
        }
        self.fileHandle.write(buffer.subdata(in: offset..<offset + count))
        // Invalidate cache as file size may have changed
        cachedLength = nil
    }

    public func writeAsync(buffer: Data, offset: Int, count: Int) async throws {
        if offset < 0 || count < 0 || offset + count > buffer.count {
            throw SwiftIOError.invalidOperation("Invalid offset or count: offset=\(offset), count=\(count), buffer.count=\(buffer.count)")
        }
        if isClosed {
            throw SwiftIOError.streamClosed
        }
        self.fileHandle.write(buffer.subdata(in: offset..<offset + count))
        // Invalidate cache as file size may have changed
        cachedLength = nil
    }

    public func writeByte(byte: UInt8) throws {
        if isClosed {
            throw SwiftIOError.streamClosed
        }
        self.fileHandle.write(Data([byte]))
        // Invalidate cache as file size may have changed
        cachedLength = nil
    }
}
