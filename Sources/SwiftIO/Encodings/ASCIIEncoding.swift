class ASCIIEncoding: Encoding {
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
