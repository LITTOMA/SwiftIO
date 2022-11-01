import Foundation

protocol Stream {
    var canRead: Bool { get }
    var canSeek: Bool { get }
    var canTimeout: Bool { get }
    var canWrite: Bool { get }
    var length: Int64 { get }
    var position: Int64 { get set }
    var readTimeout: Int32 { get }
    var writeTimeout: Int32 { get }

    func close()
    func copyTo(destination: Stream)
    func copyTo(destination: Stream, bufferSize: Int32)
    func copyToAsync(destination: Stream) async
    func copyToAsync(destination: Stream, bufferSize: Int32) async
    func flush()
    func flushAsync() async
    func read(buffer: inout Data, offset: Int32, count: Int32) -> Int32
    func readAsync(buffer: inout Data, offset: Int32, count: Int32) async -> Int32
    func readByte() -> UInt8
    func seek(offset: Int64, origin: SeekOrigin) -> Int64
    func setLength(length: Int64)
    func write(buffer: Data, offset: Int32, count: Int32)
    func writeAsync(buffer: Data, offset: Int32, count: Int32) async
    func writeByte(byte: UInt8)
}