 import Foundation

 public class BinaryReader {
    private var stream: Stream
    private var isClosed: Bool = false
    private var endianess: Endianess = .little
    private var encoding: Encoding = ASCIIEncoding()

    public init(_ stream: Stream, encoding: Encoding? = nil, endianess: Endianess = .little) {
        self.stream = stream
        self.encoding = encoding ?? ASCIIEncoding()
        self.endianess = endianess
    }

    public func close() {
        self.stream.close()
        self.isClosed = true
    }

    public func readByte() throws -> UInt8 {
        return try self.stream.readByte()
    }

    public func readBytes(_ count: Int) throws -> Data {
        var buffer = Data(count: count)
        let bytesRead = try self.stream.read(buffer: &buffer, offset: 0, count: count)
        if bytesRead == 0 {
            throw SwiftIOError.endOfStream
        }
        return buffer
    }

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

    public func readChar() throws -> Character {
        return try self.readChar(encoding: self.encoding)
    }

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

    public func readChars(_ count: Int) throws -> [Character] {
        return try self.readChars(count, encoding: self.encoding)
    }

    public func readInt16(endianess: Endianess) throws -> Int16 {
        let buffer = try self.readBytes(2)
        if endianess == Endianess.big {
            return BinaryPrimitives.readInt16BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readInt16LittleEndian(from: buffer)
        }
    }

    public func readInt16() throws -> Int16 {
        return try self.readInt16(endianess: self.endianess)
    }

    public func readInt32(endianess: Endianess) throws -> Int32 {
        let buffer = try self.readBytes(4)
        if endianess == Endianess.big {
            return BinaryPrimitives.readInt32BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readInt32LittleEndian(from: buffer)
        }
    }

    public func readInt32() throws -> Int32 {
        return try self.readInt32(endianess: self.endianess)
    }

    public func readInt64(endianess: Endianess) throws -> Int64 {
        let buffer = try self.readBytes(8)
        if endianess == Endianess.big {
            return BinaryPrimitives.readInt64BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readInt64LittleEndian(from: buffer)
        }
    }

    public func readInt64() throws -> Int64 {
        return try self.readInt64(endianess: self.endianess)
    }

    public func readUInt16(endianess: Endianess) throws -> UInt16 {
        let buffer = try self.readBytes(2)
        if endianess == Endianess.big {
            return BinaryPrimitives.readUInt16BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readUInt16LittleEndian(from: buffer)
        }
    }

    public func readUInt16() throws -> UInt16 {
        return try self.readUInt16(endianess: self.endianess)
    }

    public func readUInt32(endianess: Endianess) throws -> UInt32 {
        let buffer = try self.readBytes(4)
        if endianess == Endianess.big {
            return BinaryPrimitives.readUInt32BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readUInt32LittleEndian(from: buffer)
        }
    }

    public func readUInt32() throws -> UInt32 {
        return try self.readUInt32(endianess: self.endianess)
    }

    public func readUInt64(endianess: Endianess) throws -> UInt64 {
        let buffer = try self.readBytes(8)
        if endianess == Endianess.big {
            return BinaryPrimitives.readUInt64BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readUInt64LittleEndian(from: buffer)
        }
    }

    public func readUInt64() throws -> UInt64 {
        return try self.readUInt64(endianess: self.endianess)
    }

    public func readString(_ count: Int, encoding: Encoding) throws -> String {
        let chars = try self.readChars(count, encoding: encoding)
        return String(chars)
    }

    public func readString(_ count: Int) throws -> String {
        return try self.readString(count, encoding: self.encoding)
    }

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
