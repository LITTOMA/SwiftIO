import Foundation

/// A stream whose backing store is memory, similar to .NET's MemoryStream class.
///
/// MemoryStream creates a stream whose backing store is memory. It provides methods for reading from
/// and writing to a resizable array of bytes. This is useful for working with data in memory without
/// needing to use files or other I/O resources.
public class MemoryStream: Stream {
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
  
  /// Gets or sets the length in bytes of the stream.
  public var length: Int
  
  /// Gets or sets the position within the stream.
  public var position: Int
  
  /// Gets or sets a value that determines how long the stream will attempt to read before timing out.
  public var readTimeout: Int
  
  /// Gets or sets a value that determines how long the stream will attempt to write before timing out.
  public var writeTimeout: Int

  private var bytes: Data
  private var isClosed: Bool = false
  
  deinit {
    if !isClosed {
      close()
    }
  }

  /// Initializes a new instance of the MemoryStream class with an expandable capacity initialized to zero.
  public init() {
    self.bytes = Data()
    self.length = 0
    self.position = 0
    self.readTimeout = 0
    self.writeTimeout = 0
  }

  /// Initializes a new instance of the MemoryStream class based on the specified byte array.
  /// - Parameter bytes: The array of unsigned bytes from which to create the stream.
  public init(bytes: Data) {
    self.bytes = bytes
    self.length = bytes.count
    self.position = 0
    self.readTimeout = 0
    self.writeTimeout = 0
  }

  /// Initializes a new instance of the MemoryStream class based on the specified byte array.
  /// - Parameter bytes: The array of unsigned bytes from which to create the stream.
  public init(bytes: [UInt8]) {
    self.bytes = Data(bytes)
    self.length = bytes.count
    self.position = 0
    self.readTimeout = 0
    self.writeTimeout = 0
  }

  /// Closes the stream and releases any resources associated with it.
  public func close() {
    self.bytes = Data()
    self.length = 0
    self.position = 0
    self.isClosed = true
  }

  public func copyTo(destination: Stream) throws {
    try self.copyTo(destination: destination, bufferSize: 4096)
  }

  public func copyTo(destination: Stream, bufferSize: Int) throws {
    var buffer = Data(count: bufferSize)
    var read: Int = 0
    repeat {
      read = try self.read(buffer: &buffer, offset: 0, count: bufferSize)
      if read > 0 {
        try destination.write(buffer: buffer, offset: 0, count: read)
      }
    } while read > 0
  }

  public func copyToAsync(destination: Stream) async throws {
    try await self.copyToAsync(destination: destination, bufferSize: 4096)
  }

  public func copyToAsync(destination: Stream, bufferSize: Int) async throws {
    var buffer = Data(count: bufferSize)
    var read: Int = 0
    repeat {
      read = try await self.readAsync(buffer: &buffer, offset: 0, count: bufferSize)
      if read > 0 {
        try await destination.writeAsync(buffer: buffer, offset: 0, count: read)
      }
    } while read > 0
  }

  public func flush() throws {
    // Do nothing
  }

  public func flushAsync() async throws {
    // Do nothing
  }

  public func read(buffer: inout Data, offset: Int, count: Int) throws -> Int {
    if isClosed {
      throw SwiftIOError.streamClosed
    }
    if offset < 0 || count < 0 || offset + count > buffer.count {
      throw SwiftIOError.invalidOperation("Invalid offset or count: offset=\(offset), count=\(count), buffer.count=\(buffer.count)")
    }
    let remaining = self.length - self.position
    let read = min(count, remaining)
    if read > 0 {
      buffer.withUnsafeMutableBytes { (ptr: UnsafeMutableRawBufferPointer) in
        let base = ptr.baseAddress!
        let dest = base.advanced(by: offset)
        self.bytes.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
          let base = ptr.baseAddress!
          let src = base.advanced(by: self.position)
          dest.copyMemory(from: src, byteCount: read)
        }
      }
      self.position += read
    }
    return read
  }

  public func readAsync(buffer: inout Data, offset: Int, count: Int) async throws -> Int {
    return try self.read(buffer: &buffer, offset: offset, count: count)
  }

  public func readByte() throws -> UInt8 {
    if isClosed {
      throw SwiftIOError.streamClosed
    }
    if self.position >= self.bytes.count {
      throw SwiftIOError.endOfStream
    }
    let byte = self.bytes[self.position]
    self.position += 1
    return byte
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

    let bytes = self.bytes
    let currentLength = bytes.count
    if length > currentLength {
      let padding = Data(count: length - currentLength)
      self.bytes.append(padding)
    } else if length < currentLength {
      self.bytes.removeLast(currentLength - length)
    }

    self.length = self.bytes.count
    // Adjust position if it's beyond new length
    if self.position > self.length {
      self.position = self.length
    }
  }

  func toArray() -> [UInt8] {
    return Array(self.bytes)
  }

  func toData() -> Data {
    return self.bytes
  }

  public func write(buffer: Data, offset: Int, count: Int) throws {
    // writes a sequence of bytes to the current stream and advances the current position within this stream by the number of bytes written.
    if isClosed {
      throw SwiftIOError.streamClosed
    }

    if offset < 0 || count < 0 || offset + count > buffer.count {
      throw SwiftIOError.invalidOperation("Invalid offset or count: offset=\(offset), count=\(count), buffer.count=\(buffer.count)")
    }

    if self.position + count > self.length {
      try self.setLength(length: self.position + count)
    }

    buffer.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
      let base = ptr.baseAddress!
      let src = base.advanced(by: offset)
      self.bytes.withUnsafeMutableBytes { (destPtr: UnsafeMutableRawBufferPointer) in
        let destBase = destPtr.baseAddress!
        let dest = destBase.advanced(by: self.position)
        dest.copyMemory(from: src, byteCount: count)
      }
    }

    self.position += count
    self.length = self.bytes.count
  }

  public func writeAsync(buffer: Data, offset: Int, count: Int) async throws {
    try self.write(buffer: buffer, offset: offset, count: count)
  }

  public func writeByte(byte: UInt8) throws {
    if isClosed {
      throw SwiftIOError.streamClosed
    }
    if self.position >= self.bytes.count {
      self.bytes.append(byte)
    } else {
      self.bytes[self.position] = byte
    }
    self.position += 1
    self.length = self.bytes.count
  }
}
