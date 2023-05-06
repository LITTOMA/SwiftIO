class UTF16Encoding : Encoding {

    override func getByteCount(_ char: Character) -> Int {
        return 2
    }

    override func getByteCount(_ chars: [Character], index: Int, count: Int) -> Int {
        return count * 2
    }

    override func getBytes(_ chars: [Character], charIndex: Int, charCount: Int, bytes: inout [UInt8], byteIndex: Int) -> Int {
        for i in 0..<charCount {
            let char = chars[charIndex + i]
            let charCode = char.unicodeScalars.first!.value
            bytes[byteIndex + i * 2] = UInt8(charCode & 0xFF)
            bytes[byteIndex + i * 2 + 1] = UInt8((charCode >> 8) & 0xFF)
        }
        return charCount * 2
    }

    override func getCharCount(_ bytes: [UInt8], index: Int, count: Int) -> Int {
        return count / 2
    }

    override func getChars(_ bytes: [UInt8], byteIndex: Int, byteCount: Int, chars: inout [Character], charIndex: Int) -> Int {
        for i in 0..<byteCount / 2 {
            let charCode = (UInt32(bytes[byteIndex + i * 2 + 1]) << 8) | UInt32(bytes[byteIndex + i * 2])
            chars[charIndex + i] = Character(UnicodeScalar(charCode)!)
        }
        return byteCount / 2
    }

    override func getMaxByteCount(_ charCount: Int) -> Int {
        return charCount * 2
    }

    override func getMaxCharCount(_ byteCount: Int) -> Int {
        return byteCount / 2
    }
}