import Foundation

class Encoding {
    // "Abstract" functions
    func getByteCount(_ chars: [Character], index: Int, count: Int) -> Int {
        preconditionFailure("This method must be overridden")
    }

    func getBytes(_ chars: [Character], charIndex: Int, charCount: Int, bytes: inout [UInt8], byteIndex: Int) -> Int {
        preconditionFailure("This method must be overridden")
    }

    func getCharCount(_ bytes: [UInt8], index: Int, count: Int) -> Int {
        preconditionFailure("This method must be overridden")
    }

    func getChars(_ bytes: [UInt8], byteIndex: Int, byteCount: Int, chars: inout [Character], charIndex: Int) -> Int {
        preconditionFailure("This method must be overridden")
    }

    func getMaxByteCount(_ charCount: Int) -> Int {
        preconditionFailure("This method must be overridden")
    }

    func getMaxCharCount(_ byteCount: Int) -> Int {
        preconditionFailure("This method must be overridden")
    }
    // End of "abstract" functions

    // Static members
    static let ascii = ASCIIEncoding()
    static let utf8 = UTF8Encoding()
    static let utf16 = UTF16Encoding()
    static let utf16be = BigEndianUTF16Encoding()
    // End of static members

    func getByteCount(_ chars: [Character]) -> Int {
        return self.getByteCount(chars, index: 0, count: chars.count)
    }

    func getByteCount(_ s: String, index: Int, count: Int) -> Int {
        return self.getByteCount(Array(s), index: index, count: count)
    }

    func getByteCount(_ s: String) -> Int {
        return self.getByteCount(s, index: 0, count: s.count)
    }

    func getBytes(_ chars: [Character], charIndex: Int, charCount: Int) -> [UInt8] {
        var bytes = [UInt8](repeating: 0, count: self.getByteCount(chars, index: charIndex, count: charCount))
        self.getBytes(chars, charIndex: charIndex, charCount: charCount, bytes: &bytes, byteIndex: 0)
        return bytes
    }

    func getBytes(_ chars: [Character]) -> [UInt8] {
        return self.getBytes(chars, charIndex: 0, charCount: chars.count)
    }

    func getBytes(_ s: String, index: Int, count: Int) -> [UInt8] {
        return self.getBytes(Array(s), charIndex: index, charCount: count)
    }

    func getBytes(_ s: String) -> [UInt8] {
        return self.getBytes(s, index: 0, count: s.count)
    }

    func getCharCount(_ bytes: [UInt8]) -> Int {
        return self.getCharCount(bytes, index: 0, count: bytes.count)
    }

    func getChars(_ bytes: [UInt8], index: Int, count: Int) -> [Character] {
        var chars = [Character](repeating: " ", count: self.getCharCount(bytes, index: index, count: count))
        self.getChars(bytes, byteIndex: index, byteCount: count, chars: &chars, charIndex: 0)
        return chars
    }

    func getChars(_ bytes: [UInt8]) -> [Character] {
        return self.getChars(bytes, index: 0, count: bytes.count)
    }

    func getString(_ bytes: [UInt8], index: Int, count: Int) -> String {
        return String(self.getChars(bytes, index: index, count: count))
    }

    func getString(_ bytes: [UInt8]) -> String {
        return self.getString(bytes, index: 0, count: bytes.count)
    }
}