/// Specifies the byte order (endianness) for multi-byte data types.
public enum Endianess { 
    /// Big-endian byte order (most significant byte first).
    case big
    /// Little-endian byte order (least significant byte first).
    case little
}

/// Specifies the format of a string when reading from or writing to a binary stream.
public enum BinaryStringFormat { 
    /// Zero-terminated string (null-terminated).
    case zeroTerminated
    /// String with a single-byte length prefix.
    case bytePrefixLength
    /// String with a 16-bit unsigned integer length prefix.
    case uint16PrefixLength
    /// String with a 32-bit unsigned integer length prefix.
    case uint32PrefixLength
    /// String with a 64-bit unsigned integer length prefix.
    case uint64PrefixLength
}

/// Specifies how the operating system should open a file.
public enum FileMode : Int32 {
    /// Creates a new file. If the file already exists, an exception is thrown.
    case createNew = 1
    /// Creates a new file. If the file already exists, it will be overwritten.
    case create
    /// Opens an existing file. If the file does not exist, an exception is thrown.
    case open
    /// Opens a file if it exists; otherwise, creates a new file.
    case openOrCreate
    /// Opens an existing file and truncates it to zero bytes. If the file does not exist, an exception is thrown.
    case truncate
    /// Opens the file if it exists and seeks to the end of the file, or creates a new file.
    case append
}

/// Provides the reference point for seeking operations.
public enum SeekOrigin : Int32 {
    /// Specifies the beginning of a stream.
    case begin = 0
    /// Specifies the current position within a stream.
    case current
    /// Specifies the end of a stream.
    case end
}