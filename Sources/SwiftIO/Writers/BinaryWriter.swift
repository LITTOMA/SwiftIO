import Foundation

/// Writes primitive types in binary to a stream and supports writing strings in a specific encoding, similar to .NET's BinaryWriter class.
///
/// BinaryWriter provides methods that simplify writing primitive data types to a stream. It supports
/// different encodings for character data and different byte orders (endianness) for multi-byte values.
public class BinaryWriter {
    private var stream: Stream
    private var isClosed: Bool = false
    private var endianess: Endianess = .little
    private var encoding: Encoding = ASCIIEncoding()

    /// Initializes a new instance of the BinaryWriter class based on the specified stream and using ASCII encoding.
    /// - Parameters:
    ///   - stream: The output stream.
    ///   - encoding: The character encoding to use. If nil, defaults to ASCII encoding.
    ///   - endianess: The byte order to use when writing multi-byte values. Defaults to little-endian.
    public init(_ stream: Stream, encoding: Encoding? = nil, endianess: Endianess = .little) {
        self.stream = stream
        self.encoding = encoding ?? ASCIIEncoding()
        self.endianess = endianess
    }

    /// Closes the current writer and the underlying stream.
    public func close() {
        if !isClosed {
            self.stream.close()
            self.isClosed = true
        }
    }

    /// Writes an unsigned byte to the current stream and advances the stream position by one byte.
    /// - Parameter value: The unsigned byte to write.
    /// - Throws: `SwiftIOError.streamClosed` if the stream is closed, or other `SwiftIOError` if an I/O error occurs.
    public func writeByte(_ value: UInt8) throws {
        guard !isClosed else {
            throw SwiftIOError.streamClosed
        }
        try stream.writeByte(byte: value)
    }

    /// Writes a byte array to the underlying stream.
    /// - Parameter bytes: A byte array containing the data to write.
    /// - Throws: `SwiftIOError.streamClosed` if the stream is closed, or other `SwiftIOError` if an I/O error occurs.
    public func writeBytes(_ bytes: Data) throws {
        guard !isClosed else {
            throw SwiftIOError.streamClosed
        }
        try stream.write(buffer: bytes, offset: 0, count: bytes.count)
    }

    /// Writes a byte array to the underlying stream.
    /// - Parameter bytes: A byte array containing the data to write.
    /// - Throws: `SwiftIOError.streamClosed` if the stream is closed, or other `SwiftIOError` if an I/O error occurs.
    public func writeBytes(_ bytes: [UInt8]) throws {
        try writeBytes(Data(bytes))
    }

    /// Writes a character to the stream using the specified encoding
    /// - Parameters:
    ///   - value: The character to write
    ///   - encoding: The encoding to use
    public func writeChar(_ value: Character, encoding: Encoding) throws {
        let bytes = encoding.getBytes([value])
        try writeBytes(bytes)
    }

    /// Writes a character to the stream using the default encoding
    /// - Parameter value: The character to write
    public func writeChar(_ value: Character) throws {
        try writeChar(value, encoding: self.encoding)
    }

    /// Writes an array of characters to the stream using the specified encoding
    /// - Parameters:
    ///   - chars: The characters to write
    ///   - encoding: The encoding to use
    public func writeChars(_ chars: [Character], encoding: Encoding) throws {
        let bytes = encoding.getBytes(chars)
        try writeBytes(bytes)
    }

    /// Writes an array of characters to the stream using the default encoding
    /// - Parameter chars: The characters to write
    public func writeChars(_ chars: [Character]) throws {
        try writeChars(chars, encoding: self.encoding)
    }

    /// Writes a string to the stream using the specified encoding
    /// - Parameters:
    ///   - value: The string to write
    ///   - encoding: The encoding to use
    public func writeString(_ value: String, encoding: Encoding) throws {
        try writeChars(Array(value), encoding: encoding)
    }

    /// Writes a string to the stream using the default encoding
    /// - Parameter value: The string to write
    public func writeString(_ value: String) throws {
        try writeString(value, encoding: self.encoding)
    }

    /// Writes a string to the stream with a specific format
    /// - Parameters:
    ///   - value: The string to write
    ///   - format: The format to use (zero-terminated, length-prefixed, etc.)
    ///   - encoding: The encoding to use
    public func writeString(_ value: String, format: BinaryStringFormat, encoding: Encoding) throws {
        switch format {
        case .zeroTerminated:
            try writeString(value, encoding: encoding)
            try writeByte(0)
        case .bytePrefixLength:
            let bytes = encoding.getBytes(value)
            if bytes.count > 255 {
                throw SwiftIOError.invalidOperation("String too long for byte prefix format: \(bytes.count) bytes")
            }
            try writeByte(UInt8(bytes.count))
            try writeBytes(bytes)
        case .uint16PrefixLength:
            let bytes = encoding.getBytes(value)
            if bytes.count > UInt16.max {
                throw SwiftIOError.invalidOperation("String too long for UInt16 prefix format: \(bytes.count) bytes")
            }
            try writeUInt16(UInt16(bytes.count))
            try writeBytes(bytes)
        case .uint32PrefixLength:
            let bytes = encoding.getBytes(value)
            try writeUInt32(UInt32(bytes.count))
            try writeBytes(bytes)
        case .uint64PrefixLength:
            let bytes = encoding.getBytes(value)
            try writeUInt64(UInt64(bytes.count))
            try writeBytes(bytes)
        }
    }

    /// Writes a string to the stream with a specific format using the default encoding
    /// - Parameters:
    ///   - value: The string to write
    ///   - format: The format to use
    public func writeString(_ value: String, format: BinaryStringFormat) throws {
        try writeString(value, format: format, encoding: self.encoding)
    }

    /// Writes an Int16 value with the specified byte order
    /// - Parameters:
    ///   - value: The value to write
    ///   - endianess: The byte order to use
    public func writeInt16(_ value: Int16, endianess: Endianess) throws {
        var data = Data(count: 2)
        if endianess == .big {
            BinaryPrimitives.writeInt16BigEndian(value, to: &data, at: 0)
        } else {
            BinaryPrimitives.writeInt16LittleEndian(value, to: &data, at: 0)
        }
        try writeBytes(data)
    }

    /// Writes an Int16 value using the default byte order
    /// - Parameter value: The value to write
    public func writeInt16(_ value: Int16) throws {
        try writeInt16(value, endianess: self.endianess)
    }

    /// Writes an Int32 value with the specified byte order
    /// - Parameters:
    ///   - value: The value to write
    ///   - endianess: The byte order to use
    public func writeInt32(_ value: Int32, endianess: Endianess) throws {
        var data = Data(count: 4)
        if endianess == .big {
            BinaryPrimitives.writeInt32BigEndian(value, to: &data, at: 0)
        } else {
            BinaryPrimitives.writeInt32LittleEndian(value, to: &data, at: 0)
        }
        try writeBytes(data)
    }

    /// Writes an Int32 value using the default byte order
    /// - Parameter value: The value to write
    public func writeInt32(_ value: Int32) throws {
        try writeInt32(value, endianess: self.endianess)
    }

    /// Writes an Int64 value with the specified byte order
    /// - Parameters:
    ///   - value: The value to write
    ///   - endianess: The byte order to use
    public func writeInt64(_ value: Int64, endianess: Endianess) throws {
        var data = Data(count: 8)
        if endianess == .big {
            BinaryPrimitives.writeInt64BigEndian(value, to: &data, at: 0)
        } else {
            BinaryPrimitives.writeInt64LittleEndian(value, to: &data, at: 0)
        }
        try writeBytes(data)
    }

    /// Writes an Int64 value using the default byte order
    /// - Parameter value: The value to write
    public func writeInt64(_ value: Int64) throws {
        try writeInt64(value, endianess: self.endianess)
    }

    /// Writes a UInt16 value with the specified byte order
    /// - Parameters:
    ///   - value: The value to write
    ///   - endianess: The byte order to use
    public func writeUInt16(_ value: UInt16, endianess: Endianess) throws {
        var data = Data(count: 2)
        if endianess == .big {
            BinaryPrimitives.writeUInt16BigEndian(value, to: &data, at: 0)
        } else {
            BinaryPrimitives.writeUInt16LittleEndian(value, to: &data, at: 0)
        }
        try writeBytes(data)
    }

    /// Writes a UInt16 value using the default byte order
    /// - Parameter value: The value to write
    public func writeUInt16(_ value: UInt16) throws {
        try writeUInt16(value, endianess: self.endianess)
    }

    /// Writes a UInt32 value with the specified byte order
    /// - Parameters:
    ///   - value: The value to write
    ///   - endianess: The byte order to use
    public func writeUInt32(_ value: UInt32, endianess: Endianess) throws {
        var data = Data(count: 4)
        if endianess == .big {
            BinaryPrimitives.writeUInt32BigEndian(value, to: &data, at: 0)
        } else {
            BinaryPrimitives.writeUInt32LittleEndian(value, to: &data, at: 0)
        }
        try writeBytes(data)
    }

    /// Writes a UInt32 value using the default byte order
    /// - Parameter value: The value to write
    public func writeUInt32(_ value: UInt32) throws {
        try writeUInt32(value, endianess: self.endianess)
    }

    /// Writes a UInt64 value with the specified byte order
    /// - Parameters:
    ///   - value: The value to write
    ///   - endianess: The byte order to use
    public func writeUInt64(_ value: UInt64, endianess: Endianess) throws {
        var data = Data(count: 8)
        if endianess == .big {
            BinaryPrimitives.writeUInt64BigEndian(value, to: &data, at: 0)
        } else {
            BinaryPrimitives.writeUInt64LittleEndian(value, to: &data, at: 0)
        }
        try writeBytes(data)
    }

    /// Writes a UInt64 value using the default byte order
    /// - Parameter value: The value to write
    public func writeUInt64(_ value: UInt64) throws {
        try writeUInt64(value, endianess: self.endianess)
    }

    /// Writes a Float value with the specified byte order
    /// - Parameters:
    ///   - value: The value to write
    ///   - endianess: The byte order to use
    public func writeFloat(_ value: Float, endianess: Endianess) throws {
        var data = Data(count: 4)
        if endianess == .big {
            BinaryPrimitives.writeFloatBigEndian(value, to: &data, at: 0)
        } else {
            BinaryPrimitives.writeFloatLittleEndian(value, to: &data, at: 0)
        }
        try writeBytes(data)
    }

    /// Writes a Float value using the default byte order
    /// - Parameter value: The value to write
    public func writeFloat(_ value: Float) throws {
        try writeFloat(value, endianess: self.endianess)
    }

    /// Writes a Double value with the specified byte order
    /// - Parameters:
    ///   - value: The value to write
    ///   - endianess: The byte order to use
    public func writeDouble(_ value: Double, endianess: Endianess) throws {
        var data = Data(count: 8)
        if endianess == .big {
            BinaryPrimitives.writeDoubleBigEndian(value, to: &data, at: 0)
        } else {
            BinaryPrimitives.writeDoubleLittleEndian(value, to: &data, at: 0)
        }
        try writeBytes(data)
    }

    /// Writes a Double value using the default byte order
    /// - Parameter value: The value to write
    public func writeDouble(_ value: Double) throws {
        try writeDouble(value, endianess: self.endianess)
    }

    /// Flushes the underlying stream
    public func flush() throws {
        try stream.flush()
    }

    /// Flushes the underlying stream asynchronously
    public func flushAsync() async throws {
        try await stream.flushAsync()
    }
    
    // MARK: - Result callback versions
    
    public func writeByte(_ value: UInt8, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeByte(value)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeBytes(_ bytes: Data, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeBytes(bytes)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeInt16(_ value: Int16, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeInt16(value)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeInt32(_ value: Int32, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeInt32(value)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeInt64(_ value: Int64, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeInt64(value)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeString(_ value: String, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeString(value)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func flush(completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try flush()
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeChar(_ value: Character, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeChar(value)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeChar(_ value: Character, encoding: Encoding, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeChar(value, encoding: encoding)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeChars(_ chars: [Character], completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeChars(chars)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeChars(_ chars: [Character], encoding: Encoding, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeChars(chars, encoding: encoding)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeString(_ value: String, encoding: Encoding, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeString(value, encoding: encoding)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeString(_ value: String, format: BinaryStringFormat, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeString(value, format: format)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeString(_ value: String, format: BinaryStringFormat, encoding: Encoding, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeString(value, format: format, encoding: encoding)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeUInt16(_ value: UInt16, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeUInt16(value)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeUInt32(_ value: UInt32, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeUInt32(value)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeUInt64(_ value: UInt64, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeUInt64(value)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeFloat(_ value: Float, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeFloat(value)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func writeDouble(_ value: Double, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeDouble(value)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func flushAsync(completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        Task {
            do {
                try await flushAsync()
                completion(.success(()))
            } catch let error as SwiftIOError {
                completion(.failure(error))
            } catch {
                completion(.failure(.invalidOperation("Unknown error: \(error)")))
            }
        }
    }
}

