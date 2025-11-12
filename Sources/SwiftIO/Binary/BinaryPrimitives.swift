import Foundation

/// Provides methods for reading and writing primitive data types with specific byte orders, similar to .NET's BinaryPrimitives class.
///
/// BinaryPrimitives provides static methods for converting between primitive types and their byte representations
/// with explicit control over byte order (endianness). This is useful when reading or writing binary data formats
/// that require specific byte ordering.
public class BinaryPrimitives {
    // MARK: - Helper methods
    
    /// Helper function to swap bytes for big-endian conversion.
    private static func swapBytes<T: FixedWidthInteger>(_ value: T) -> T {
        return value.byteSwapped
    }
    
    // MARK: - Reading methods (Big Endian)
    
    /// Reads a Double value from the beginning of a read-only span of bytes, as big endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readDoubleBigEndian(from data: Data) -> Double {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: Double.self)
            // If system is little-endian, swap bytes
            #if _endian(little)
            return Double(bitPattern: swapBytes(value.bitPattern))
            #else
            return value
            #endif
        }
    }

    // MARK: - Reading methods (Little Endian)
    
    /// Reads a Double value from the beginning of a read-only span of bytes, as little endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readDoubleLittleEndian(from data: Data) -> Double {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: Double.self)
            // If system is big-endian, swap bytes
            #if _endian(big)
            return Double(bitPattern: swapBytes(value.bitPattern))
            #else
            return value
            #endif
        }
    }

    /// Reads a Float value from the beginning of a read-only span of bytes, as big endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readFloatBigEndian(from data: Data) -> Float {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: Float.self)
            #if _endian(little)
            return Float(bitPattern: swapBytes(value.bitPattern))
            #else
            return value
            #endif
        }
    }

    /// Reads a Float value from the beginning of a read-only span of bytes, as little endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readFloatLittleEndian(from data: Data) -> Float {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: Float.self)
            #if _endian(big)
            return Float(bitPattern: swapBytes(value.bitPattern))
            #else
            return value
            #endif
        }
    }

    /// Reads an Int16 value from the beginning of a read-only span of bytes, as big endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readInt16BigEndian(from data: Data) -> Int16 {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: Int16.self)
            #if _endian(little)
            return swapBytes(value)
            #else
            return value
            #endif
        }
    }

    /// Reads an Int16 value from the beginning of a read-only span of bytes, as little endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readInt16LittleEndian(from data: Data) -> Int16 {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: Int16.self)
            #if _endian(big)
            return swapBytes(value)
            #else
            return value
            #endif
        }
    }

    /// Reads an Int32 value from the beginning of a read-only span of bytes, as big endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readInt32BigEndian(from data: Data) -> Int32 {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: Int32.self)
            #if _endian(little)
            return swapBytes(value)
            #else
            return value
            #endif
        }
    }

    /// Reads an Int32 value from the beginning of a read-only span of bytes, as little endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readInt32LittleEndian(from data: Data) -> Int32 {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: Int32.self)
            #if _endian(big)
            return swapBytes(value)
            #else
            return value
            #endif
        }
    }

    /// Reads an Int64 value from the beginning of a read-only span of bytes, as big endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readInt64BigEndian(from data: Data) -> Int64 {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: Int64.self)
            #if _endian(little)
            return swapBytes(value)
            #else
            return value
            #endif
        }
    }

    /// Reads an Int64 value from the beginning of a read-only span of bytes, as little endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readInt64LittleEndian(from data: Data) -> Int64 {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: Int64.self)
            #if _endian(big)
            return swapBytes(value)
            #else
            return value
            #endif
        }
    }

    /// Reads an Int8 value from the beginning of a read-only span of bytes.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readInt8(from data: Data) -> Int8 {
        return data.withUnsafeBytes { $0.load(as: Int8.self) }
    }
    
    /// Reads a Float value from the beginning of a read-only span of bytes, as big endian.
    /// This is an alias for `readFloatBigEndian`.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readSingleBigEndian(from data: Data) -> Float {
        return readFloatBigEndian(from: data)
    }

    /// Reads a Float value from the beginning of a read-only span of bytes, as little endian.
    /// This is an alias for `readFloatLittleEndian`.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readSingleLittleEndian(from data: Data) -> Float {
        return readFloatLittleEndian(from: data)
    }

    /// Reads a UInt16 value from the beginning of a read-only span of bytes, as big endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readUInt16BigEndian(from data: Data) -> UInt16 {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: UInt16.self)
            #if _endian(little)
            return swapBytes(value)
            #else
            return value
            #endif
        }
    }

    /// Reads a UInt16 value from the beginning of a read-only span of bytes, as little endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readUInt16LittleEndian(from data: Data) -> UInt16 {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: UInt16.self)
            #if _endian(big)
            return swapBytes(value)
            #else
            return value
            #endif
        }
    }

    /// Reads a UInt32 value from the beginning of a read-only span of bytes, as big endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readUInt32BigEndian(from data: Data) -> UInt32 {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: UInt32.self)
            #if _endian(little)
            return swapBytes(value)
            #else
            return value
            #endif
        }
    }

    /// Reads a UInt32 value from the beginning of a read-only span of bytes, as little endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readUInt32LittleEndian(from data: Data) -> UInt32 {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: UInt32.self)
            #if _endian(big)
            return swapBytes(value)
            #else
            return value
            #endif
        }
    }

    /// Reads a UInt64 value from the beginning of a read-only span of bytes, as big endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readUInt64BigEndian(from data: Data) -> UInt64 {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: UInt64.self)
            #if _endian(little)
            return swapBytes(value)
            #else
            return value
            #endif
        }
    }

    /// Reads a UInt64 value from the beginning of a read-only span of bytes, as little endian.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readUInt64LittleEndian(from data: Data) -> UInt64 {
        return data.withUnsafeBytes { ptr in
            let value = ptr.load(as: UInt64.self)
            #if _endian(big)
            return swapBytes(value)
            #else
            return value
            #endif
        }
    }

    /// Reads a UInt8 value from the beginning of a read-only span of bytes.
    /// - Parameter data: The read-only span of bytes to read from.
    /// - Returns: The value read from the span.
    static func readUInt8(from data: Data) -> UInt8 {
        return data.withUnsafeBytes { $0.load(as: UInt8.self) }
    }

    // MARK: - Writing methods (Big Endian)

    /// Writes a Double value into a span of bytes, as big endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeDoubleBigEndian(_ value: Double, to data: inout Data, at offset: Int = 0) {
        var swappedValue = value
        #if _endian(little)
        swappedValue = Double(bitPattern: swapBytes(value.bitPattern))
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: Double.self)
        }
    }

    // MARK: - Writing methods (Little Endian)

    /// Writes a Double value into a span of bytes, as little endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeDoubleLittleEndian(_ value: Double, to data: inout Data, at offset: Int = 0) {
        var swappedValue = value
        #if _endian(big)
        swappedValue = Double(bitPattern: swapBytes(value.bitPattern))
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: Double.self)
        }
    }

    /// Writes a Float value into a span of bytes, as big endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeFloatBigEndian(_ value: Float, to data: inout Data, at offset: Int = 0) {
        var swappedValue = value
        #if _endian(little)
        swappedValue = Float(bitPattern: swapBytes(value.bitPattern))
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: Float.self)
        }
    }

    /// Writes a Float value into a span of bytes, as little endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeFloatLittleEndian(_ value: Float, to data: inout Data, at offset: Int = 0) {
        var swappedValue = value
        #if _endian(big)
        swappedValue = Float(bitPattern: swapBytes(value.bitPattern))
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: Float.self)
        }
    }

    /// Writes an Int16 value into a span of bytes, as big endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeInt16BigEndian(_ value: Int16, to data: inout Data, at offset: Int = 0) {
        #if _endian(little)
        let swappedValue = swapBytes(value)
        #else
        let swappedValue = value
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: Int16.self)
        }
    }

    /// Writes an Int16 value into a span of bytes, as little endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeInt16LittleEndian(_ value: Int16, to data: inout Data, at offset: Int = 0) {
        #if _endian(big)
        let swappedValue = swapBytes(value)
        #else
        let swappedValue = value
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: Int16.self)
        }
    }

    /// Writes an Int32 value into a span of bytes, as big endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeInt32BigEndian(_ value: Int32, to data: inout Data, at offset: Int = 0) {
        #if _endian(little)
        let swappedValue = swapBytes(value)
        #else
        let swappedValue = value
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: Int32.self)
        }
    }

    /// Writes an Int32 value into a span of bytes, as little endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeInt32LittleEndian(_ value: Int32, to data: inout Data, at offset: Int = 0) {
        #if _endian(big)
        let swappedValue = swapBytes(value)
        #else
        let swappedValue = value
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: Int32.self)
        }
    }

    /// Writes an Int64 value into a span of bytes, as big endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeInt64BigEndian(_ value: Int64, to data: inout Data, at offset: Int = 0) {
        #if _endian(little)
        let swappedValue = swapBytes(value)
        #else
        let swappedValue = value
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: Int64.self)
        }
    }

    /// Writes an Int64 value into a span of bytes, as little endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeInt64LittleEndian(_ value: Int64, to data: inout Data, at offset: Int = 0) {
        #if _endian(big)
        let swappedValue = swapBytes(value)
        #else
        let swappedValue = value
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: Int64.self)
        }
    }

    /// Writes an Int8 value into a span of bytes.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeInt8(_ value: Int8, to data: inout Data, at offset: Int = 0) {
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: value, toByteOffset: offset, as: Int8.self)
        }
    }

    /// Writes a Float value into a span of bytes, as big endian.
    /// This is an alias for `writeFloatBigEndian`.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeSingleBigEndian(_ value: Float, to data: inout Data, at offset: Int = 0) {
        writeFloatBigEndian(value, to: &data, at: offset)
    }

    /// Writes a Float value into a span of bytes, as little endian.
    /// This is an alias for `writeFloatLittleEndian`.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeSingleLittleEndian(_ value: Float, to data: inout Data, at offset: Int = 0) {
        writeFloatLittleEndian(value, to: &data, at: offset)
    }

    /// Writes a UInt16 value into a span of bytes, as big endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeUInt16BigEndian(_ value: UInt16, to data: inout Data, at offset: Int = 0) {
        #if _endian(little)
        let swappedValue = swapBytes(value)
        #else
        let swappedValue = value
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: UInt16.self)
        }
    }

    /// Writes a UInt16 value into a span of bytes, as little endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeUInt16LittleEndian(_ value: UInt16, to data: inout Data, at offset: Int = 0) {
        #if _endian(big)
        let swappedValue = swapBytes(value)
        #else
        let swappedValue = value
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: UInt16.self)
        }
    }

    /// Writes a UInt32 value into a span of bytes, as big endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeUInt32BigEndian(_ value: UInt32, to data: inout Data, at offset: Int = 0) {
        #if _endian(little)
        let swappedValue = swapBytes(value)
        #else
        let swappedValue = value
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: UInt32.self)
        }
    }

    /// Writes a UInt32 value into a span of bytes, as little endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeUInt32LittleEndian(_ value: UInt32, to data: inout Data, at offset: Int = 0) {
        #if _endian(big)
        let swappedValue = swapBytes(value)
        #else
        let swappedValue = value
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: UInt32.self)
        }
    }

    /// Writes a UInt64 value into a span of bytes, as big endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeUInt64BigEndian(_ value: UInt64, to data: inout Data, at offset: Int = 0) {
        #if _endian(little)
        let swappedValue = swapBytes(value)
        #else
        let swappedValue = value
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: UInt64.self)
        }
    }

    /// Writes a UInt64 value into a span of bytes, as little endian.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeUInt64LittleEndian(_ value: UInt64, to data: inout Data, at offset: Int = 0) {
        #if _endian(big)
        let swappedValue = swapBytes(value)
        #else
        let swappedValue = value
        #endif
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: swappedValue, toByteOffset: offset, as: UInt64.self)
        }
    }

    /// Writes a UInt8 value into a span of bytes.
    /// - Parameters:
    ///   - value: The value to write.
    ///   - data: The span of bytes where the value is to be written.
    ///   - offset: The offset at which to start writing. Defaults to 0.
    static func writeUInt8(_ value: UInt8, to data: inout Data, at offset: Int = 0) {
        data.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: value, toByteOffset: offset, as: UInt8.self)
        }
    }
}