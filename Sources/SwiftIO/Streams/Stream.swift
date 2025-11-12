import Foundation

public protocol Stream {
    var canRead: Bool { get }
    var canSeek: Bool { get }
    var canTimeout: Bool { get }
    var canWrite: Bool { get }
    var length: Int { get }
    var position: Int { get set }
    var readTimeout: Int { get }
    var writeTimeout: Int { get }

    func close()
    
    // Throwing versions
    func copyTo(destination: Stream) throws
    func copyTo(destination: Stream, bufferSize: Int) throws
    func copyToAsync(destination: Stream) async throws
    func copyToAsync(destination: Stream, bufferSize: Int) async throws
    func flush() throws
    func flushAsync() async throws
    func read(buffer: inout Data, offset: Int, count: Int) throws -> Int
    func readAsync(buffer: inout Data, offset: Int, count: Int) async throws -> Int
    func readByte() throws -> UInt8
    func seek(offset: Int, origin: SeekOrigin) throws -> Int
    func setLength(length: Int) throws
    func write(buffer: Data, offset: Int, count: Int) throws
    func writeAsync(buffer: Data, offset: Int, count: Int) async throws
    func writeByte(byte: UInt8) throws
    
    // Result callback versions (non-throwing)
    func copyTo(destination: Stream, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    func copyTo(destination: Stream, bufferSize: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    func copyToAsync(destination: Stream, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    func copyToAsync(destination: Stream, bufferSize: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    func flush(completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    func flushAsync(completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    func read(buffer: inout Data, offset: Int, count: Int, completion: @escaping (Result<Int, SwiftIOError>) -> Void)
    func readAsync(buffer: inout Data, offset: Int, count: Int, completion: @escaping (Result<Int, SwiftIOError>) -> Void)
    func readByte(completion: @escaping (Result<UInt8, SwiftIOError>) -> Void)
    func seek(offset: Int, origin: SeekOrigin, completion: @escaping (Result<Int, SwiftIOError>) -> Void)
    func setLength(length: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    func write(buffer: Data, offset: Int, count: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    func writeAsync(buffer: Data, offset: Int, count: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    func writeByte(byte: UInt8, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
}

// Default implementations using protocol extension
public extension Stream {
    func copyTo(destination: Stream, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try copyTo(destination: destination)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    func copyTo(destination: Stream, bufferSize: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try copyTo(destination: destination, bufferSize: bufferSize)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    func flush(completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try flush()
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    func read(buffer: inout Data, offset: Int, count: Int, completion: @escaping (Result<Int, SwiftIOError>) -> Void) {
        // Swift's concurrency checker prevents inout parameters from being accessed
        // in escaping closures. The solution is to complete all buffer modifications
        // synchronously before executing the callback, even though the callback is @escaping.
        // Since the read operation itself is synchronous, executing the callback
        // synchronously is safe and avoids concurrent access issues.
        let result: Result<Int, SwiftIOError>
        
        do {
            let bytesRead = try read(buffer: &buffer, offset: offset, count: count)
            result = .success(bytesRead)
        } catch let error as SwiftIOError {
            result = .failure(error)
        } catch {
            result = .failure(.invalidOperation("Unknown error: \(error)"))
        }
        
        // Execute callback synchronously to avoid inout parameter access conflicts
        // The buffer modification is already complete, so this is safe
        completion(result)
    }
    
    func readByte(completion: @escaping (Result<UInt8, SwiftIOError>) -> Void) {
        do {
            let result = try readByte()
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    func seek(offset: Int, origin: SeekOrigin, completion: @escaping (Result<Int, SwiftIOError>) -> Void) {
        do {
            let result = try seek(offset: offset, origin: origin)
            completion(.success(result))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    func setLength(length: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try setLength(length: length)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    func write(buffer: Data, offset: Int, count: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try write(buffer: buffer, offset: offset, count: count)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    func writeByte(byte: UInt8, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        do {
            try writeByte(byte: byte)
            completion(.success(()))
        } catch let error as SwiftIOError {
            completion(.failure(error))
        } catch {
            completion(.failure(.invalidOperation("Unknown error: \(error)")))
        }
    }
    
    func copyToAsync(destination: Stream, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        Task {
            do {
                try await copyToAsync(destination: destination)
                completion(.success(()))
            } catch let error as SwiftIOError {
                completion(.failure(error))
            } catch {
                completion(.failure(.invalidOperation("Unknown error: \(error)")))
            }
        }
    }
    
    func copyToAsync(destination: Stream, bufferSize: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        Task {
            do {
                try await copyToAsync(destination: destination, bufferSize: bufferSize)
                completion(.success(()))
            } catch let error as SwiftIOError {
                completion(.failure(error))
            } catch {
                completion(.failure(.invalidOperation("Unknown error: \(error)")))
            }
        }
    }
    
    func flushAsync(completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        Task {
            do {
                try await flushAsync()
                completion(.success(()))
            } catch let error as SwiftIOError {
                completion(.failure(error))
            } catch {
                completion(.failure(.invalidOperation("Unknown error: \(error)")))
            }
        }
    }
    
    func readAsync(buffer: inout Data, offset: Int, count: Int, completion: @escaping (Result<Int, SwiftIOError>) -> Void) {
        // For callback version with inout parameter, we need to avoid concurrent access
        // Create a local copy, perform the read, then update the original buffer synchronously
        // before executing the callback asynchronously
        var localBuffer = buffer
        let result: Result<Int, SwiftIOError>
        
        do {
            let bytesRead = try read(buffer: &localBuffer, offset: offset, count: count)
            buffer = localBuffer  // Update buffer synchronously before async callback
            result = .success(bytesRead)
        } catch let error as SwiftIOError {
            result = .failure(error)
        } catch {
            result = .failure(.invalidOperation("Unknown error: \(error)"))
        }
        
        // Execute callback asynchronously to provide async behavior
        DispatchQueue.global().async {
            completion(result)
        }
    }
    
    func writeAsync(buffer: Data, offset: Int, count: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void) {
        Task {
            do {
                try await writeAsync(buffer: buffer, offset: offset, count: count)
                completion(.success(()))
            } catch let error as SwiftIOError {
                completion(.failure(error))
            } catch {
                completion(.failure(.invalidOperation("Unknown error: \(error)")))
            }
        }
    }
}