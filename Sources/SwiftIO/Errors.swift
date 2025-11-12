import Foundation

/// Errors that can occur during IO operations
public enum SwiftIOError: Error {
    /// End of stream reached
    case endOfStream
    /// File does not exist
    case fileNotFound(String)
    /// Invalid operation (e.g., invalid length, offset, or count)
    case invalidOperation(String)
    /// Stream is closed
    case streamClosed
    /// Encoding error
    case encodingError(String)
}

