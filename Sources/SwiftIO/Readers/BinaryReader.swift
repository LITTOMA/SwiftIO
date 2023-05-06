 import Foundation

 class BinaryReader {
    private var stream: Stream
    private var isClosed: Bool = false
    private var endianess: Endianess = .little
    private var encoding: Encoding = ASCIIEncoding()

    init(_ stream: Stream, encoding: Encoding = ASCIIEncoding(), endianess: Endianess = .little) {
        self.stream = stream
        self.encoding = encoding
        self.endianess = endianess
    }

    func close() {
        self.stream.close()
        self.isClosed = true
    }

    func readByte() -> UInt8 {
        var buffer = Data(count: 1)
        let bytesRead = self.stream.read(buffer: &buffer, offset: 0, count: 1)
        if bytesRead == 0 {
            fatalError("End of stream")
        }
        return buffer[0]
    }

    func readBytes(_ count: Int) -> Data {
        var buffer = Data(count: count)
        let bytesRead = self.stream.read(buffer: &buffer, offset: 0, count: Int32(count))
        if bytesRead == 0 {
            fatalError("End of stream")
        }
        return buffer
    }

    func readChar(encoding: Encoding) -> Character {
        let bytes = self.readBytes(encoding.getMaxByteCount(1))
        let chars = encoding.getChars(Array(bytes))
        self.stream.position -= Int64(bytes.count - encoding.getByteCount(chars))
        return chars[0]
    }

    func readChar() -> Character {
        return self.readChar(encoding: self.encoding)
    }

    func readChars(_ count: Int, encoding: Encoding) -> [Character] {
        let chars = [Character](repeating: " ", count: count)
        var charsRead = 0
        for i in 0..<count {
            let char = self.readChar(encoding: encoding)
            if char == "" {
                break
            }
            chars[charsRead] = char
            charsRead += 1
        }
    }

    func readChars(_ count: Int) -> [Character] {
        return self.readChars(count, encoding: self.encoding)
    }

    func readInt16(endianess: Endianess) -> Int16 {
        let buffer = self.readBytes(2)
        if endianess == Endianess.big {
            return BinaryPrimitives.readInt16BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readInt16LittleEndian(from: buffer)
        }
    }

    func readInt16() -> Int16 {
        return self.readInt16(endianess: self.endianess)
    }

    func readInt32(endianess: Endianess) -> Int32 {
        let buffer = self.readBytes(4)
        if endianess == Endianess.big {
            return BinaryPrimitives.readInt32BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readInt32LittleEndian(from: buffer)
        }
    }

    func readInt32() -> Int32 {
        return self.readInt32(endianess: self.endianess)
    }

    func readInt64(endianess: Endianess) -> Int64 {
        let buffer = self.readBytes(8)
        if endianess == Endianess.big {
            return BinaryPrimitives.readInt64BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readInt64LittleEndian(from: buffer)
        }
    }

    func readInt64() -> Int64 {
        return self.readInt64(endianess: self.endianess)
    }

    func readUInt16(endianess: Endianess) -> UInt16 {
        let buffer = self.readBytes(2)
        if endianess == Endianess.big {
            return BinaryPrimitives.readUInt16BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readUInt16LittleEndian(from: buffer)
        }
    }

    func readUInt16() -> UInt16 {
        return self.readUInt16(endianess: self.endianess)
    }

    func readUInt32(endianess: Endianess) -> UInt32 {
        let buffer = self.readBytes(4)
        if endianess == Endianess.big {
            return BinaryPrimitives.readUInt32BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readUInt32LittleEndian(from: buffer)
        }
    }

    func readUInt32() -> UInt32 {
        return self.readUInt32(endianess: self.endianess)
    }

    func readUInt64(endianess: Endianess) -> UInt64 {
        let buffer = self.readBytes(8)
        if endianess == Endianess.big {
            return BinaryPrimitives.readUInt64BigEndian(from: buffer)
        } else {
            return BinaryPrimitives.readUInt64LittleEndian(from: buffer)
        }
    }

    func readUInt64() -> UInt64 {
        return self.readUInt64(endianess: self.endianess)
    }

    func readString(_ count: Int, encoding: Encoding) -> String {
        let chars = self.readChars(count, encoding: encoding)
        return String(chars)
    }

    func readString(_ count: Int) -> String {
        return self.readString(count, encoding: self.encoding)
    }

    func readString(format: BinaryStringFormat, encoding: Encoding) -> String {
        switch format {
        case .zeroTerminated:
            var chars: [Character] = []
            while true {
                let c = self.readChar(encoding: encoding)
                if c == "\0" {
                    break
                }
                chars.append(c)
            }
            return String(chars)
        case .bytePrefixLength:
            let length = Int(self.readByte())
            return self.readString(length, encoding: encoding)
        case .uint16PrefixLength:
            let length = Int(self.readUInt16())
            return self.readString(length, encoding: encoding)
        case .uint32PrefixLength:
            let length = Int(self.readUInt32())
            return self.readString(length, encoding: encoding)
        case .uint64PrefixLength:
            let length = Int(self.readUInt64())
            return self.readString(length, encoding: encoding)
        }
    }

    func readString(format: BinaryStringFormat) -> String {
        return self.readString(format: format, encoding: self.encoding)
    }

    func readToEnd() -> Data {
        var buffer = Data()
        while true {
            var chunk = Data(count: 4096)
            let bytesRead = self.stream.read(buffer: &chunk, offset: 0, count: 4096)
            if bytesRead == 0 {
                break
            }
            buffer.append(chunk)
        }
        return buffer
    }
}
