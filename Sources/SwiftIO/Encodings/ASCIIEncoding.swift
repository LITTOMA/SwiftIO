/// Represents an ASCII character encoding of Unicode characters, similar to .NET's ASCIIEncoding class.
///
/// ASCIIEncoding encodes Unicode characters as single 7-bit ASCII characters. Characters with Unicode values
/// greater than U+007F are converted to the ASCII question mark ("?") character.
public class ASCIIEncoding: Encoding {
    /// Initializes a new instance of the ASCIIEncoding class.
    public override init() {
        super.init()
    }
    override func getByteCount(_ char: Character) -> Int {
        return 1
    }

    override func getByteCount(_ chars: [Character], index: Int, count: Int) -> Int {
        return count
    }

    override func getBytes(_ chars: [Character], charIndex: Int, charCount: Int, bytes: inout [UInt8], byteIndex: Int) -> Int {
        for i in 0..<charCount {
            bytes[byteIndex + i] = UInt8(chars[charIndex + i].asciiValue!)
        }
        return charCount
    }

    override func getCharCount(_ bytes: [UInt8], index: Int, count: Int) -> Int {
        return count
    }

    override func getChars(_ bytes: [UInt8], byteIndex: Int, byteCount: Int, chars: inout [Character], charIndex: Int) -> Int {
        for i in 0..<byteCount {
            chars[charIndex + i] = Character(UnicodeScalar(bytes[byteIndex + i]))
        }
        return byteCount
    }

    override func getMaxByteCount(_ charCount: Int) -> Int {
        return charCount
    }
    
    override func getMaxCharCount(_ byteCount: Int) -> Int {
        return byteCount
    }
}
