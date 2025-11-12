 import Foundation

 /// Reads primitive data types as binary values in a specific encoding, similar to .NET's BinaryReader class.
 ///
 /// BinaryReader provides methods that simplify reading primitive data types from a stream. It supports
 /// different encodings for character data and different byte orders (endianness) for multi-byte values.
 public class BinaryReader {
    private var stream: Stream
    private var isClosed: Bool = false
    private var endianess: Endianess = .little
    private var encoding: Encoding = ASCIIEncoding()

    /// Initializes a new instance of the BinaryReader class based on the specified stream and using UTF-8 encoding.
    /// - Parameters:
    ///   - stream: The input stream.
    ///   - encoding: The character encoding to use. If nil, defaults to ASCII encoding.
    ///   - endianess: The byte order to use when reading multi-byte values. Defaults to little-endian.
    public init(_ stream: Stream, encoding: Encoding? = nil, endianess: Endianess = .little) {
        self.stream = stream
        self.encoding = encoding ?? ASCIIEncoding()
        self.endianess = endianess
    }

    /// Closes the current reader and the underlying stream.
    public func close() {
        self.stream.close()
        self.isClosed = true
    }

    /// Reads the next byte from the current stream and advances the current position of the stream by one byte.
    /// - Returns: The next byte read from the current stream.
    /// - Throws: `SwiftIOError.endOfStream` if the end of the stream is reached, or other `SwiftIOError` if an I/O error occurs.
    public func readByte() throws -> UInt8 {
        return try self.stream.readByte()
    }

    /// Reads the specified number of bytes from the current stream into a byte array and advances the current position by that number of bytes.
    /// - Parameter count: The number of bytes to read.
    /// - Returns: A byte array containing data read from the underlying stream.
    /// - Throws: `SwiftIOError.endOfStream` if the end of the stream is reached before reading the requested number of bytes, or other `SwiftIOError` if an I/O error occurs.
    public func readBytes(_ count: Int) throws -> Data {
        var buffer = Data(count: count)
        let bytesRead = try self.stream.read(buffer: &buffer, offset: 0, count: count)
        if bytesRead == 0 {
            throw SwiftIOError.endOfStream
        }
        return buffer
    }

    /// Reads the next character from the current stream using the specified encoding and advances the current position of the stream.
    /// - Parameter encoding: The encoding to use for reading the character.
    /// - Returns: A character read from the current stream, or null character if the end of the stream is reached.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readChar(encoding: Encoding) throws -> Character {
        // if stream reaches end, return null character
        if self.stream.position == self.stream.length {
            return "\0"
        }

        var maxBytes = encoding.getMaxByteCount(1)
        if maxBytes + self.stream.position > self.stream.length {
            maxBytes = self.stream.length - self.stream.position
        }

        let bytes = try self.readBytes(maxBytes)
        let chars = encoding.getChars(Array(bytes))
        let char = chars[0]
        self.stream.position -= bytes.count - encoding.getByteCount(char)
        return char
    }

    /// Reads the next character from the current stream using the default encoding.
    /// - Returns: A character read from the current stream, or null character if the end of the stream is reached.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readChar() throws -> Character {
        return try self.readChar(encoding: self.encoding)
    }

    /// Reads the specified number of characters from the current stream using the specified encoding.
    /// - Parameters:
    ///   - count: The number of characters to read.
    ///   - encoding: The encoding to use for reading the characters.
    /// - Returns: An array of characters read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readChars(_ count: Int, encoding: Encoding) throws -> [Character] {
        var chars = [Character](repeating: " ", count: count)
        var charsRead = 0
        for i in 0..<count {
            let char = try self.readChar(encoding: encoding)
            chars[i] = char
            charsRead += 1
        }
        return chars
    }

    /// Reads the specified number of characters from the current stream using the default encoding.
    /// - Parameter count: The number of characters to read.
    /// - Returns: An array of characters read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readChars(_ count: Int) throws -> [Character] {
        return try self.readChars(count, encoding: self.encoding)
    }

    /// Reads a 2-byte signed integer from the current stream using the specified byte order and advances the position of the stream by two bytes.
    /// - Parameter endianess: The byte order to use when reading the value.
    /// - Returns: A 2-byte signed integer read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readInt16(endianess: Endianess) throws -> Int16 {
        let buffer = try self.readBytes(2)
        if endianess == Endianess.big {
            return BinaryPrimitives.readInt16BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readInt16LittleEndian(from: buffer)
        }
    }

    /// Reads a 2-byte signed integer from the current stream using the default byte order and advances the position of the stream by two bytes.
    /// - Returns: A 2-byte signed integer read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readInt16() throws -> Int16 {
        return try self.readInt16(endianess: self.endianess)
    }

    /// Reads a 4-byte signed integer from the current stream using the specified byte order and advances the position of the stream by four bytes.
    /// - Parameter endianess: The byte order to use when reading the value.
    /// - Returns: A 4-byte signed integer read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readInt32(endianess: Endianess) throws -> Int32 {
        let buffer = try self.readBytes(4)
        if endianess == Endianess.big {
            return BinaryPrimitives.readInt32BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readInt32LittleEndian(from: buffer)
        }
    }

    /// Reads a 4-byte signed integer from the current stream using the default byte order and advances the position of the stream by four bytes.
    /// - Returns: A 4-byte signed integer read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readInt32() throws -> Int32 {
        return try self.readInt32(endianess: self.endianess)
    }

    /// Reads an 8-byte signed integer from the current stream using the specified byte order and advances the position of the stream by eight bytes.
    /// - Parameter endianess: The byte order to use when reading the value.
    /// - Returns: An 8-byte signed integer read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readInt64(endianess: Endianess) throws -> Int64 {
        let buffer = try self.readBytes(8)
        if endianess == Endianess.big {
            return BinaryPrimitives.readInt64BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readInt64LittleEndian(from: buffer)
        }
    }

    /// Reads an 8-byte signed integer from the current stream using the default byte order and advances the position of the stream by eight bytes.
    /// - Returns: An 8-byte signed integer read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readInt64() throws -> Int64 {
        return try self.readInt64(endianess: self.endianess)
    }

    /// Reads a 2-byte unsigned integer from the current stream using the specified byte order and advances the position of the stream by two bytes.
    /// - Parameter endianess: The byte order to use when reading the value.
    /// - Returns: A 2-byte unsigned integer read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readUInt16(endianess: Endianess) throws -> UInt16 {
        let buffer = try self.readBytes(2)
        if endianess == Endianess.big {
            return BinaryPrimitives.readUInt16BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readUInt16LittleEndian(from: buffer)
        }
    }

    /// Reads a 2-byte unsigned integer from the current stream using the default byte order and advances the position of the stream by two bytes.
    /// - Returns: A 2-byte unsigned integer read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readUInt16() throws -> UInt16 {
        return try self.readUInt16(endianess: self.endianess)
    }

    /// Reads a 4-byte unsigned integer from the current stream using the specified byte order and advances the position of the stream by four bytes.
    /// - Parameter endianess: The byte order to use when reading the value.
    /// - Returns: A 4-byte unsigned integer read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readUInt32(endianess: Endianess) throws -> UInt32 {
        let buffer = try self.readBytes(4)
        if endianess == Endianess.big {
            return BinaryPrimitives.readUInt32BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readUInt32LittleEndian(from: buffer)
        }
    }

    /// Reads a 4-byte unsigned integer from the current stream using the default byte order and advances the position of the stream by four bytes.
    /// - Returns: A 4-byte unsigned integer read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readUInt32() throws -> UInt32 {
        return try self.readUInt32(endianess: self.endianess)
    }

    /// Reads an 8-byte unsigned integer from the current stream using the specified byte order and advances the position of the stream by eight bytes.
    /// - Parameter endianess: The byte order to use when reading the value.
    /// - Returns: An 8-byte unsigned integer read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readUInt64(endianess: Endianess) throws -> UInt64 {
        let buffer = try self.readBytes(8)
        if endianess == Endianess.big {
            return BinaryPrimitives.readUInt64BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readUInt64LittleEndian(from: buffer)
        }
    }

    /// Reads an 8-byte unsigned integer from the current stream using the default byte order and advances the position of the stream by eight bytes.
    /// - Returns: An 8-byte unsigned integer read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readUInt64() throws -> UInt64 {
        return try self.readUInt64(endianess: self.endianess)
    }

    /// Reads a string from the current stream using the specified encoding and character count.
    /// - Parameters:
    ///   - count: The number of characters to read.
    ///   - encoding: The encoding to use for reading the string.
    /// - Returns: A string read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readString(_ count: Int, encoding: Encoding) throws -> String {
        let chars = try self.readChars(count, encoding: encoding)
        return String(chars)
    }

    /// Reads a string from the current stream using the default encoding and character count.
    /// - Parameter count: The number of characters to read.
    /// - Returns: A string read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readString(_ count: Int) throws -> String {
        return try self.readString(count, encoding: self.encoding)
    }

    /// Reads a string from the current stream using the specified format and encoding.
    /// - Parameters:
    ///   - format: The format of the string in the stream (zero-terminated, length-prefixed, etc.).
    ///   - encoding: The encoding to use for reading the string.
    /// - Returns: A string read from the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    public func readString(format: BinaryStringFormat, encoding: Encoding) throws -> String {
        switch format {
        case .zeroTerminated:
            var chars: [Character] = []
            while true {
                let c = try self.readChar(encoding: encoding)
                if c == "\0" {
                    break
                }
                chars.append(c)
            }
            return String(chars)
        case .bytePrefixLength:
            let length = Int(try self.readByte())
            return try self.readString(length, encoding: encoding)
        case .uint16PrefixLength:
            let length = Int(try self.readUInt16())
            return try self.readString(length, encoding: encoding)
        case .uint32PrefixLength:
            let length = Int(try self.readUInt32())
            return try self.readString(length, encoding: encoding)
        case .uint64PrefixLength:
            let length = Int(try self.readUInt64())
            return try self.readString(length, encoding: encoding)
        }
    }

    public func readString(format: BinaryStringFormat) throws -> String {
        return try self.readString(format: format, encoding: self.encoding)
    }

    public func readToEnd() throws -> Data {
        var buffer = Data()
        while true {
            var chunk = Data(count: 4096)
            let bytesRead = try self.stream.read(buffer: &chunk, offset: 0, count: 4096)
            if bytesRead == 0 {
                break
            }
            buffer.append(chunk)
        }
        return buffer
    }
    
    // MARK: - Result callback versions
    
    public func readByte(completion: @escaping (Result<UInt8, SwiftIOError>) -> Void) {
        do {
            let result = try readByte()
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readBytes(_ count: Int, completion: @escaping (Result<Data, SwiftIOError>) -> Void) {
        do {
            let result = try readBytes(count)
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readInt16(completion: @escaping (Result<Int16, SwiftIOError>) -> Void) {
        do {
            let result = try readInt16()
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readInt32(completion: @escaping (Result<Int32, SwiftIOError>) -> Void) {
        do {
            let result = try readInt32()
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readInt64(completion: @escaping (Result<Int64, SwiftIOError>) -> Void) {
        do {
            let result = try readInt64()
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readString(_ count: Int, completion: @escaping (Result<String, SwiftIOError>) -> Void) {
        do {
            let result = try readString(count)
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readChar(completion: @escaping (Result<Character, SwiftIOError>) -> Void) {
        do {
            let result = try readChar()
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readChar(encoding: Encoding, completion: @escaping (Result<Character, SwiftIOError>) -> Void) {
        do {
            let result = try readChar(encoding: encoding)
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readChars(_ count: Int, completion: @escaping (Result<[Character], SwiftIOError>) -> Void) {
        do {
            let result = try readChars(count)
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readChars(_ count: Int, encoding: Encoding, completion: @escaping (Result<[Character], SwiftIOError>) -> Void) {
        do {
            let result = try readChars(count, encoding: encoding)
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readUInt16(completion: @escaping (Result<UInt16, SwiftIOError>) -> Void) {
        do {
            let result = try readUInt16()
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readUInt32(completion: @escaping (Result<UInt32, SwiftIOError>) -> Void) {
        do {
            let result = try readUInt32()
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readUInt64(completion: @escaping (Result<UInt64, SwiftIOError>) -> Void) {
        do {
            let result = try readUInt64()
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readString(format: BinaryStringFormat, completion: @escaping (Result<String, SwiftIOError>) -> Void) {
        do {
            let result = try readString(format: format)
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readString(format: BinaryStringFormat, encoding: Encoding, completion: @escaping (Result<String, SwiftIOError>) -> Void) {
        do {
            let result = try readString(format: format, encoding: encoding)
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readString(_ count: Int, encoding: Encoding, completion: @escaping (Result<String, SwiftIOError>) -> Void) {
        do {
            let result = try readString(count, encoding: encoding)
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    public func readToEnd(completion: @escaping (Result<Data, SwiftIOError>) -> Void) {
        do {
            let result = try readToEnd()
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
}
