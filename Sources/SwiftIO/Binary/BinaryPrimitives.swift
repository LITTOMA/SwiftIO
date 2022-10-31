import Foundation

class BinaryPrimitives {
    static func readDoubleBigEndian(from data: Data) -> Double {
        // take the first 8 bytes and reverse them
        let bytes = data.prefix(8).reversed()

        // convert the bytes to a Data object
        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: Double.self) }
        return value
    }

    static func readDoubleLittleEndian(from data: Data) -> Double {
        let bytes = data.prefix(8)

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: Double.self) }
        return value
    }

    static func readFloatBigEndian(from data: Data) -> Float {
        let bytes = data.prefix(4).reversed()

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: Float.self) }
        return value
    }

    static func readFloatLittleEndian(from data: Data) -> Float {
        let bytes = data.prefix(4)

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: Float.self) }
        return value
    }

    static func readInt16BigEndian(from data: Data) -> Int16 {
        let bytes = data.prefix(2).reversed()

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: Int16.self) }
        return value
    }

    static func readInt16LittleEndian(from data: Data) -> Int16 {
        let bytes = data.prefix(2)

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: Int16.self) }
        return value
    }

    static func readInt32BigEndian(from data: Data) -> Int32 {
        let bytes = data.prefix(4).reversed()

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: Int32.self) }
        return value
    }

    static func readInt32LittleEndian(from data: Data) -> Int32 {
        let bytes = data.prefix(4)

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: Int32.self) }
        return value
    }

    static func readInt64BigEndian(from data: Data) -> Int64 {
        let bytes = data.prefix(8).reversed()

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: Int64.self) }
        return value
    }

    static func readInt64LittleEndian(from data: Data) -> Int64 {
        let bytes = data.prefix(8)

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: Int64.self) }
        return value
    }

    static func readInt8(from data: Data) -> Int8 {
        let bytes = data.prefix(1)

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: Int8.self) }
        return value
    }
    
    static func readSingleBigEndian(from data: Data) -> Float {
        let bytes = data.prefix(4).reversed()

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: Float.self) }
        return value
    }

    static func readSingleLittleEndian(from data: Data) -> Float {
        let bytes = data.prefix(4)

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: Float.self) }
        return value
    }

    static func readUInt16BigEndian(from data: Data) -> UInt16 {
        let bytes = data.prefix(2).reversed()

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: UInt16.self) }
        return value
    }

    static func readUInt16LittleEndian(from data: Data) -> UInt16 {
        let bytes = data.prefix(2)

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: UInt16.self) }
        return value
    }

    static func readUInt32BigEndian(from data: Data) -> UInt32 {
        let bytes = data.prefix(4).reversed()

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: UInt32.self) }
        return value
    }

    static func readUInt32LittleEndian(from data: Data) -> UInt32 {
        let bytes = data.prefix(4)

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: UInt32.self) }
        return value
    }

    static func readUInt64BigEndian(from data: Data) -> UInt64 {
        let bytes = data.prefix(8).reversed()

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: UInt64.self) }
        return value
    }

    static func readUInt64LittleEndian(from data: Data) -> UInt64 {
        let bytes = data.prefix(8)

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: UInt64.self) }
        return value
    }

    static func readUInt8(from data: Data) -> UInt8 {
        let bytes = data.prefix(1)

        let data = Data(bytes)

        let value = data.withUnsafeBytes { $0.load(as: UInt8.self) }
        return value
    }

    static func writeDoubleBigEndian(_ value: Double, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+8, with: bytes.reversed())
    }

    static func writeDoubleLittleEndian(_ value: Double, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+8, with: bytes)
    }

    static func writeFloatBigEndian(_ value: Float, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+4, with: bytes.reversed())
    }

    static func writeFloatLittleEndian(_ value: Float, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+4, with: bytes)
    }

    static func writeInt16BigEndian(_ value: Int16, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+2, with: bytes.reversed())
    }

    static func writeInt16LittleEndian(_ value: Int16, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+2, with: bytes)
    }

    static func writeInt32BigEndian(_ value: Int32, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+4, with: bytes.reversed())
    }

    static func writeInt32LittleEndian(_ value: Int32, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+4, with: bytes)
    }

    static func writeInt64BigEndian(_ value: Int64, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+8, with: bytes.reversed())
    }

    static func writeInt64LittleEndian(_ value: Int64, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+8, with: bytes)
    }

    static func writeInt8(_ value: Int8, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+1, with: bytes)
    }

    static func writeSingleBigEndian(_ value: Float, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+4, with: bytes.reversed())
    }

    static func writeSingleLittleEndian(_ value: Float, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+4, with: bytes)
    }

    static func writeUInt16BigEndian(_ value: UInt16, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+2, with: bytes.reversed())
    }

    static func writeUInt16LittleEndian(_ value: UInt16, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+2, with: bytes)
    }

    static func writeUInt32BigEndian(_ value: UInt32, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+4, with: bytes.reversed())
    }

    static func writeUInt32LittleEndian(_ value: UInt32, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+4, with: bytes)
    }

    static func writeUInt64BigEndian(_ value: UInt64, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+8, with: bytes.reversed())
    }

    static func writeUInt64LittleEndian(_ value: UInt64, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+8, with: bytes)
    }

    static func writeUInt8(_ value: UInt8, to data: inout Data, at offset: Int = 0) {
        var value = value
        let bytes = withUnsafeBytes(of: &value) { Data($0) }
        data.replaceSubrange(offset..<offset+1, with: bytes)
    }
}