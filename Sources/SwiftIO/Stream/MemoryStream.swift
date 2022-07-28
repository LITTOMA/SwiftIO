import Foundation

class MemoryStream: Stream {
  var canRead: Bool {
    return !isClosed
  }
  var canSeek: Bool {
    return !isClosed
  }
  var canTimeout: Bool {
    return !isClosed
  }
  var canWrite: Bool {
    return !isClosed
  }
  var length: Int64
  var position: Int64
  var readTimeout: Int32
  var writeTimeout: Int32

  private var bytes: Data
  private var isClosed: Bool = false

  init() {
    self.bytes = Data()
    self.length = 0
    self.position = 0
    self.readTimeout = 0
    self.writeTimeout = 0
  }

  init(bytes: Data) {
    self.bytes = bytes
    self.length = Int64(bytes.count)
    self.position = 0
    self.readTimeout = 0
    self.writeTimeout = 0
  }

  init(bytes: [UInt8]) {
    self.bytes = Data(bytes)
    self.length = Int64(bytes.count)
    self.position = 0
    self.readTimeout = 0
    self.writeTimeout = 0
  }

  func close() {
    self.bytes = Data()
    self.length = 0
    self.position = 0
    self.isClosed = true
  }

  func copyTo(destination: Stream) {
    self.copyTo(destination: destination, bufferSize: 4096)
  }

  func copyTo(destination: Stream, bufferSize: Int32) {
    var buffer = Data(count: Int(bufferSize))
    var read: Int32 = 0
    repeat {
      read = self.read(buffer: &buffer, offset: 0, count: bufferSize)
      if read > 0 {
        destination.write(buffer: buffer, offset: 0, count: read)
      }
    } while read > 0
  }

  func copyToAsync(destination: Stream) async {
    await self.copyToAsync(destination: destination, bufferSize: 4096)
  }

  func copyToAsync(destination: Stream, bufferSize: Int32) async {
    var buffer = Data(count: Int(bufferSize))
    var read: Int32 = 0
    repeat {
      read = await self.readAsync(buffer: &buffer, offset: 0, count: bufferSize)
      if read > 0 {
        await destination.writeAsync(buffer: buffer, offset: 0, count: read)
      }
    } while read > 0
  }

  func flush() {
    // Do nothing
  }

  func flushAsync() async {
    // Do nothing
  }

  func read(buffer: inout Data, offset: Int32, count: Int32) -> Int32 {
    let count = Int(count)
    let offset = Int(offset)
    let length = Int(self.length)
    let position = Int(self.position)
    let remaining = length - position
    let read = min(count, remaining)
    if read > 0 {
      buffer.withUnsafeMutableBytes { (ptr: UnsafeMutableRawBufferPointer) in
        let base = ptr.baseAddress!
        let dest = base.advanced(by: offset)
        self.bytes.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
          let base = ptr.baseAddress!
          let src = base.advanced(by: position)
          dest.copyMemory(from: src, byteCount: read)
        }
      }
      self.position += Int64(read)
    }
    return Int32(read)
  }

  func readAsync(buffer: inout Data, offset: Int32, count: Int32) async -> Int32 {
    return self.read(buffer: &buffer, offset: offset, count: count)
  }

  func readByte() -> UInt8 {
    let position = Int(self.position)
    let byte = self.bytes[position]
    self.position += 1
    return byte
  }

  func seek(offset: Int64, origin: SeekOrigin) -> Int64 {
    let length = Int64(self.length)
    let position = Int64(self.position)
    switch origin {
    case .begin:
      self.position = offset
    case .current:
      self.position = position + offset
    case .end:
      self.position = length + offset
    }
    return self.position
  }

  func setLength(length: Int64) {
    if length < 0 {
      fatalError("Invalid length")
    }

    let length = Int(length)
    let bytes = self.bytes
    let currentLength = bytes.count
    if length > currentLength {
      let padding = Data(count: length - currentLength)
      self.bytes.append(padding)
    } else if length < currentLength {
      self.bytes.removeLast(currentLength - length)
    }

    self.length = Int64(self.bytes.count)
  }

  func toArray() -> [UInt8] {
    return Array(self.bytes)
  }

  func toData() -> Data {
    return self.bytes
  }

  func write(buffer: Data, offset: Int32, count: Int32) {
    // writes a sequence of bytes to the current stream and advances the current position within this stream by the number of bytes written.
    let count = Int(count)
    let offset = Int(offset)
    let length = Int(self.length)
    let position = Int(self.position)

    if offset < 0 || count < 0 || offset + count > buffer.count {
      fatalError("Invalid offset or count")
    }

    if position + count > length {
      self.setLength(length: Int64(position + count))
    }

    buffer.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
      let base = ptr.baseAddress!
      let src = base.advanced(by: offset)
      self.bytes.withUnsafeMutableBytes { (destPtr: UnsafeMutableRawBufferPointer) in
        let destBase = destPtr.baseAddress!
        let dest = destBase.advanced(by: position)
        dest.copyMemory(from: src, byteCount: count)
      }
    }

    self.position += Int64(count)
    self.length = Int64(self.bytes.count)
  }

  func writeAsync(buffer: Data, offset: Int32, count: Int32) async {
    self.write(buffer: buffer, offset: offset, count: count)
  }

  func writeByte(byte: UInt8) {
    let position = Int(self.position)
    if position >= self.bytes.count {
      self.bytes.append(byte)
    } else {
      self.bytes[position] = byte
    }
    self.position += 1
    self.length = Int64(self.bytes.count)
  }
}
