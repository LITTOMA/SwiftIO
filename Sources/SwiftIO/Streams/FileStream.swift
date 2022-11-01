import Foundation

class FileStream: Stream {
    var canRead: Bool {
        return !isClosed
    }
    var canSeek: Bool {
        return !isClosed
    }
    var canTimeout: Bool {
        return !isClosed
    }
    var canWrite: Bool {
        return !isClosed
    }
    var length: Int64 {
        let currentOffset = self.position
        let length = Int64(fileHandle.seekToEndOfFile())
        self.position = currentOffset
        return length
    }
    var position: Int64 {
        get {
            return Int64(fileHandle.offsetInFile)
        }
        set {
            fileHandle.seek(toFileOffset: UInt64(newValue))
        }
    }
    var readTimeout: Int32
    var writeTimeout: Int32

    private var fileHandle: FileHandle
    private var isClosed: Bool = false

    init(path: String, mode: FileMode) {
        if mode == .createNew {
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        } else if mode == .create {
            if !FileManager.default.fileExists(atPath: path) {
                FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            }
        } else if mode == .open {
            if !FileManager.default.fileExists(atPath: path) {
                fatalError("File does not exist")
            }
        } else if mode == .openOrCreate {
            if !FileManager.default.fileExists(atPath: path) {
                FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            }
        } else if mode == .truncate {
            if !FileManager.default.fileExists(atPath: path) {
                FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            } else {
                let fileHandle = FileHandle(forUpdatingAtPath: path)!
                fileHandle.truncateFile(atOffset: 0)
                fileHandle.closeFile()
            }
        } else if mode == .append {
            if !FileManager.default.fileExists(atPath: path) {
                FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            }
        }

        self.fileHandle = FileHandle(forUpdatingAtPath: path)!
        self.readTimeout = 0
        self.writeTimeout = 0

        switch mode {
        case .append:
            self.fileHandle.seekToEndOfFile()
        case .create:
            self.fileHandle.truncateFile(atOffset: 0)
        case .createNew:
            self.fileHandle.truncateFile(atOffset: 0)
        case .open:
            break
        case .openOrCreate:
            break
        case .truncate:
            self.fileHandle.truncateFile(atOffset: 0)
        }
    }

    init(fileHandle: FileHandle) {
        self.fileHandle = fileHandle
        self.readTimeout = 0
        self.writeTimeout = 0
    }

    func close() {
        self.fileHandle.closeFile()
        self.isClosed = true
    }

    func copyTo(destination: Stream) {
        self.copyTo(destination: destination, bufferSize: 4096)
    }

    func copyTo(destination: Stream, bufferSize: Int32) {
        var buffer = Data(count: Int(bufferSize))
        self.position = 0

        while true {
            let bytesRead = self.read(buffer: &buffer, offset: 0, count: bufferSize)

            if bytesRead == 0 {
                break
            }

            destination.write(buffer: buffer, offset: 0, count: bytesRead)
        }
    }

    func copyToAsync(destination: Stream) async {
        await self.copyToAsync(destination: destination, bufferSize: 4096)
    }

    func copyToAsync(destination: Stream, bufferSize: Int32) async {
        var buffer = Data(count: Int(bufferSize))
        self.position = 0

        while true {
            let bytesRead = await self.readAsync(buffer: &buffer, offset: 0, count: bufferSize)

            if bytesRead == 0 {
                break
            }

            await destination.writeAsync(buffer: buffer, offset: 0, count: bytesRead)
        }
    }

    func flush() {
        self.fileHandle.synchronizeFile()
    }

    func flushAsync() async {
        self.fileHandle.synchronizeFile()
    }

    func read(buffer: inout Data, offset: Int32, count: Int32) -> Int32 {
        let data = self.fileHandle.readData(ofLength: Int(count))
        if data.count == 0 {
            return 0
        }

        buffer.replaceSubrange(Int(offset)..<Int(offset + count), with: data)
        return Int32(data.count)
    }

    func readByte() -> UInt8 {
        return self.fileHandle.readData(ofLength: 1)[0]
    }

    func readAsync(buffer: inout Data, offset: Int32, count: Int32) async -> Int32 {
        let data = self.fileHandle.readData(ofLength: Int(count))
        if data.count == 0 {
            return 0
        }
        
        buffer.replaceSubrange(Int(offset)..<Int(offset + count), with: data)
        return Int32(data.count)
    }

    func seek(offset: Int64, origin: SeekOrigin) -> Int64 {
        switch origin {
        case .begin:
            self.position = offset
        case .current:
            self.position += offset
        case .end:
            self.position = self.length + offset
        }

        return self.position
    }

    func setLength(length: Int64) {
        self.fileHandle.truncateFile(atOffset: UInt64(length))
    }

    func write(buffer: Data, offset: Int32, count: Int32) {
        self.fileHandle.write(buffer.subdata(in: Int(offset)..<Int(offset + count)))
    }

    func writeAsync(buffer: Data, offset: Int32, count: Int32) async {
        self.fileHandle.write(buffer.subdata(in: Int(offset)..<Int(offset + count)))
    }

    func writeByte(byte: UInt8) {
        self.fileHandle.write(Data([byte]))
    }
}
