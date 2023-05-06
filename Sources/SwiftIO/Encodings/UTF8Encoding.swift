class UTF8Encoding: Encoding {
    override func getByteCount(_ char: Character) -> Int {
        var byteCount = 0
        if char <= "\u{7F}" {
            byteCount += 1
        } else if char <= "\u{7FF}" {
            byteCount += 2
        } else if char <= "\u{FFFF}" {
            byteCount += 3
        } else {
            byteCount += 4
        }
        return byteCount
    }

    override func getByteCount(_ chars: [Character], index: Int, count: Int) -> Int {
        var byteCount = 0
        for i in index..<index + count {
            let char = chars[i]
            byteCount += getByteCount(char)
        }
        return byteCount
    }

    override func getBytes(_ chars: [Character], charIndex: Int, charCount: Int, bytes: inout [UInt8], byteIndex: Int) -> Int {
        var byteCount = 0
        for i in charIndex..<charIndex + charCount {
            let char = chars[i]
            if char <= "\u{7F}" {
                bytes[byteIndex + byteCount] = UInt8(char.unicodeScalars.first!.value)
                byteCount += 1
            } else if char <= "\u{7FF}" {
                bytes[byteIndex + byteCount] = UInt8(0xC0 | (char.unicodeScalars.first!.value >> 6))
                bytes[byteIndex + byteCount + 1] = UInt8(0x80 | (char.unicodeScalars.first!.value & 0x3F))
                byteCount += 2
            } else if char <= "\u{FFFF}" {
                bytes[byteIndex + byteCount] = UInt8(0xE0 | (char.unicodeScalars.first!.value >> 12))
                bytes[byteIndex + byteCount + 1] = UInt8(0x80 | ((char.unicodeScalars.first!.value >> 6) & 0x3F))
                bytes[byteIndex + byteCount + 2] = UInt8(0x80 | (char.unicodeScalars.first!.value & 0x3F))
                byteCount += 3
            } else {
                bytes[byteIndex + byteCount] = UInt8(0xF0 | (char.unicodeScalars.first!.value >> 18))
                bytes[byteIndex + byteCount + 1] = UInt8(0x80 | ((char.unicodeScalars.first!.value >> 12) & 0x3F))
                bytes[byteIndex + byteCount + 2] = UInt8(0x80 | ((char.unicodeScalars.first!.value >> 6) & 0x3F))
                bytes[byteIndex + byteCount + 3] = UInt8(0x80 | (char.unicodeScalars.first!.value & 0x3F))
                byteCount += 4
            }
        }
        return byteCount
    }

    override func getCharCount(_ bytes: [UInt8], index: Int, count: Int) -> Int {
        var charCount = 0
        var i = index
        while i < index + count {
            let byte = bytes[i]
            if byte <= 0x7F {
                charCount += 1
                i += 1
            } else if byte <= 0xDF {
                charCount += 1
                i += 2
            } else if byte <= 0xEF {
                charCount += 1
                i += 3
            } else {
                charCount += 1
                i += 4
            }
        }
        return charCount
    }

    override func getChars(_ bytes: [UInt8], byteIndex: Int, byteCount: Int, chars: inout [Character], charIndex: Int) -> Int {
        var charCount = 0
        var i = byteIndex
        while i < byteIndex + byteCount {
            let byte = bytes[i]
            if byte <= 0x7F {
                chars[charIndex + charCount] = Character(UnicodeScalar(byte))
                charCount += 1
                i += 1
            } else if byte <= 0xDF {
                let char = ((UInt32(byte) & 0x1F) << 6) | (UInt32(bytes[i + 1]) & 0x3F)
                chars[charIndex + charCount] = Character(UnicodeScalar(char) ?? UnicodeScalar(0x20))
                charCount += 1
                i += 2
            } else if byte <= 0xEF {
                let char = ((UInt32(byte) & 0x0F) << 12) | ((UInt32(bytes[i + 1]) & 0x3F) << 6) | (UInt32(bytes[i + 2]) & 0x3F)
                chars[charIndex + charCount] = Character(UnicodeScalar(char) ?? UnicodeScalar(0x20))
                charCount += 1
                i += 3
            } else {
                let char = ((UInt32(byte) & 0x07) << 18) | ((UInt32(bytes[i + 1]) & 0x3F) << 12) | ((UInt32(bytes[i + 2]) & 0x3F) << 6) | (UInt32(bytes[i + 3]) & 0x3F)
                chars[charIndex + charCount] = Character(UnicodeScalar(char) ?? UnicodeScalar(0x20))
                charCount += 1
                i += 4
            }
        }
        return charCount
    }

    override func getMaxByteCount(_ charCount: Int) -> Int {
        return charCount * 4
    }

    override func getMaxCharCount(_ byteCount: Int) -> Int {
        return byteCount
    }
}
