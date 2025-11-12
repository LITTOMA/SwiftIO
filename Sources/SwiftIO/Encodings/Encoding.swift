import Foundation

/// Represents a character encoding, similar to .NET's Encoding class.
///
/// Encoding is an abstract base class that provides methods for converting between characters and bytes.
/// Subclasses implement specific encoding schemes such as ASCII, UTF-8, and UTF-16.
public class Encoding {
    // MARK: - Abstract methods (must be overridden by subclasses)
    
    /// When overridden in a derived class, calculates the number of bytes produced by encoding the specified character.
    /// - Parameter char: The character to encode.
    /// - Returns: The number of bytes produced by encoding the specified character.
    func getByteCount(_ char: Character) -> Int {
        preconditionFailure("This method must be overridden")
    }

    /// When overridden in a derived class, calculates the number of bytes produced by encoding a set of characters from the specified character array.
    /// - Parameters:
    ///   - chars: The character array containing the characters to encode.
    ///   - index: The index of the first character to encode.
    ///   - count: The number of characters to encode.
    /// - Returns: The number of bytes produced by encoding the specified characters.
    func getByteCount(_ chars: [Character], index: Int, count: Int) -> Int {
        preconditionFailure("This method must be overridden")
    }

    /// When overridden in a derived class, encodes a set of characters from the specified character array into the specified byte array.
    /// - Parameters:
    ///   - chars: The character array containing the characters to encode.
    ///   - charIndex: The index of the first character to encode.
    ///   - charCount: The number of characters to encode.
    ///   - bytes: The byte array to contain the resulting sequence of bytes.
    ///   - byteIndex: The index at which to start writing the resulting sequence of bytes.
    /// - Returns: The actual number of bytes written into bytes.
    func getBytes(_ chars: [Character], charIndex: Int, charCount: Int, bytes: inout [UInt8], byteIndex: Int) -> Int {
        preconditionFailure("This method must be overridden")
    }

    /// When overridden in a derived class, calculates the number of characters produced by decoding a sequence of bytes from the specified byte array.
    /// - Parameters:
    ///   - bytes: The byte array containing the sequence of bytes to decode.
    ///   - index: The index of the first byte to decode.
    ///   - count: The number of bytes to decode.
    /// - Returns: The number of characters produced by decoding the specified sequence of bytes.
    func getCharCount(_ bytes: [UInt8], index: Int, count: Int) -> Int {
        preconditionFailure("This method must be overridden")
    }

    /// When overridden in a derived class, decodes a sequence of bytes from the specified byte array into the specified character array.
    /// - Parameters:
    ///   - bytes: The byte array containing the sequence of bytes to decode.
    ///   - byteIndex: The index of the first byte to decode.
    ///   - byteCount: The number of bytes to decode.
    ///   - chars: The character array to contain the resulting set of characters.
    ///   - charIndex: The index at which to start writing the resulting set of characters.
    /// - Returns: The actual number of characters written into chars.
    func getChars(_ bytes: [UInt8], byteIndex: Int, byteCount: Int, chars: inout [Character], charIndex: Int) -> Int {
        preconditionFailure("This method must be overridden")
    }

    /// When overridden in a derived class, calculates the maximum number of bytes produced by encoding the specified number of characters.
    /// - Parameter charCount: The number of characters to encode.
    /// - Returns: The maximum number of bytes produced by encoding the specified number of characters.
    func getMaxByteCount(_ charCount: Int) -> Int {
        preconditionFailure("This method must be overridden")
    }

    /// When overridden in a derived class, calculates the maximum number of characters produced by decoding the specified number of bytes.
    /// - Parameter byteCount: The number of bytes to decode.
    /// - Returns: The maximum number of characters produced by decoding the specified number of bytes.
    func getMaxCharCount(_ byteCount: Int) -> Int {
        preconditionFailure("This method must be overridden")
    }
    
    // MARK: - Static members
    
    /// Gets an encoding for the ASCII character set.
    public static let ascii = ASCIIEncoding()
    
    /// Gets an encoding for the UTF-8 format.
    public static let utf8 = UTF8Encoding()
    
    /// Gets an encoding for the UTF-16 format using the little-endian byte order.
    public static let utf16 = UTF16Encoding()
    
    /// Gets an encoding for the UTF-16 format using the big-endian byte order.
    public static let utf16be = BigEndianUTF16Encoding()
    
    // MARK: - Convenience methods

    /// Calculates the number of bytes produced by encoding all the characters in the specified character array.
    /// - Parameter chars: The character array containing the characters to encode.
    /// - Returns: The number of bytes produced by encoding all the characters in the character array.
    func getByteCount(_ chars: [Character]) -> Int {
        return self.getByteCount(chars, index: 0, count: chars.count)
    }

    /// Calculates the number of bytes produced by encoding a set of characters from the specified string.
    /// - Parameters:
    ///   - s: The string containing the characters to encode.
    ///   - index: The index of the first character to encode.
    ///   - count: The number of characters to encode.
    /// - Returns: The number of bytes produced by encoding the specified characters.
    func getByteCount(_ s: String, index: Int, count: Int) -> Int {
        return self.getByteCount(Array(s), index: index, count: count)
    }

    /// Calculates the number of bytes produced by encoding all the characters in the specified string.
    /// - Parameter s: The string containing the characters to encode.
    /// - Returns: The number of bytes produced by encoding all the characters in the string.
    func getByteCount(_ s: String) -> Int {
        return self.getByteCount(s, index: 0, count: s.count)
    }

    /// Encodes a set of characters from the specified character array into a byte array.
    /// - Parameters:
    ///   - chars: The character array containing the characters to encode.
    ///   - charIndex: The index of the first character to encode.
    ///   - charCount: The number of characters to encode.
    /// - Returns: A byte array containing the results of encoding the specified set of characters.
    func getBytes(_ chars: [Character], charIndex: Int, charCount: Int) -> [UInt8] {
        var bytes = [UInt8](repeating: 0, count: self.getByteCount(chars, index: charIndex, count: charCount))
        self.getBytes(chars, charIndex: charIndex, charCount: charCount, bytes: &bytes, byteIndex: 0)
        return bytes
    }

    /// Encodes all the characters in the specified character array into a byte array.
    /// - Parameter chars: The character array containing the characters to encode.
    /// - Returns: A byte array containing the results of encoding the specified set of characters.
    func getBytes(_ chars: [Character]) -> [UInt8] {
        return self.getBytes(chars, charIndex: 0, charCount: chars.count)
    }

    /// Encodes a set of characters from the specified string into a byte array.
    /// - Parameters:
    ///   - s: The string containing the characters to encode.
    ///   - index: The index of the first character to encode.
    ///   - count: The number of characters to encode.
    /// - Returns: A byte array containing the results of encoding the specified set of characters.
    func getBytes(_ s: String, index: Int, count: Int) -> [UInt8] {
        return self.getBytes(Array(s), charIndex: index, charCount: count)
    }

    /// Encodes all the characters in the specified string into a byte array.
    /// - Parameter s: The string containing the characters to encode.
    /// - Returns: A byte array containing the results of encoding the specified set of characters.
    func getBytes(_ s: String) -> [UInt8] {
        return self.getBytes(s, index: 0, count: s.count)
    }

    /// Calculates the number of characters produced by decoding all the bytes in the specified byte array.
    /// - Parameter bytes: The byte array containing the sequence of bytes to decode.
    /// - Returns: The number of characters produced by decoding the specified sequence of bytes.
    func getCharCount(_ bytes: [UInt8]) -> Int {
        return self.getCharCount(bytes, index: 0, count: bytes.count)
    }

    /// Decodes a sequence of bytes from the specified byte array into a character array.
    /// - Parameters:
    ///   - bytes: The byte array containing the sequence of bytes to decode.
    ///   - index: The index of the first byte to decode.
    ///   - count: The number of bytes to decode.
    /// - Returns: A character array containing the results of decoding the specified sequence of bytes.
    func getChars(_ bytes: [UInt8], index: Int, count: Int) -> [Character] {
        var chars = [Character](repeating: " ", count: self.getCharCount(bytes, index: index, count: count))
        self.getChars(bytes, byteIndex: index, byteCount: count, chars: &chars, charIndex: 0)
        return chars
    }

    /// Decodes all the bytes in the specified byte array into a character array.
    /// - Parameter bytes: The byte array containing the sequence of bytes to decode.
    /// - Returns: A character array containing the results of decoding the specified sequence of bytes.
    func getChars(_ bytes: [UInt8]) -> [Character] {
        return self.getChars(bytes, index: 0, count: bytes.count)
    }

    /// Decodes a sequence of bytes from the specified byte array into a string.
    /// - Parameters:
    ///   - bytes: The byte array containing the sequence of bytes to decode.
    ///   - index: The index of the first byte to decode.
    ///   - count: The number of bytes to decode.
    /// - Returns: A string containing the results of decoding the specified sequence of bytes.
    func getString(_ bytes: [UInt8], index: Int, count: Int) -> String {
        return String(self.getChars(bytes, index: index, count: count))
    }

    /// Decodes all the bytes in the specified byte array into a string.
    /// - Parameter bytes: The byte array containing the sequence of bytes to decode.
    /// - Returns: A string containing the results of decoding the specified sequence of bytes.
    func getString(_ bytes: [UInt8]) -> String {
        return self.getString(bytes, index: 0, count: bytes.count)
    }
}