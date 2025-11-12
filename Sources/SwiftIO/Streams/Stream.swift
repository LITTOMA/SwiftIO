import Foundation

/// A protocol that provides a generic view of a sequence of bytes, similar to .NET's Stream class.
///
/// Stream provides a way to read from and write to various data sources (files, memory, network, etc.)
/// in a uniform manner. It supports both synchronous and asynchronous operations, as well as
/// both throwing and callback-based error handling.
public protocol Stream {
    /// Indicates whether the stream supports reading.
    var canRead: Bool { get }
    
    /// Indicates whether the stream supports seeking.
    var canSeek: Bool { get }
    
    /// Indicates whether the stream can time out.
    var canTimeout: Bool { get }
    
    /// Indicates whether the stream supports writing.
    var canWrite: Bool { get }
    
    /// Gets the length in bytes of the stream.
    var length: Int { get }
    
    /// Gets or sets the position within the stream.
    var position: Int { get set }
    
    /// Gets or sets a value that determines how long the stream will attempt to read before timing out.
    var readTimeout: Int { get }
    
    /// Gets or sets a value that determines how long the stream will attempt to write before timing out.
    var writeTimeout: Int { get }

    /// Closes the stream and releases any resources associated with it.
    func close()
    
    // MARK: - Throwing versions
    
    /// Reads all bytes from the current stream and writes them to another stream.
    /// - Parameter destination: The stream to which the contents of the current stream will be copied.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    func copyTo(destination: Stream) throws
    
    /// Reads all bytes from the current stream and writes them to another stream using the specified buffer size.
    /// - Parameters:
    ///   - destination: The stream to which the contents of the current stream will be copied.
    ///   - bufferSize: The size of the buffer to use for copying. Default is 4096 bytes.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    func copyTo(destination: Stream, bufferSize: Int) throws
    
    /// Asynchronously reads all bytes from the current stream and writes them to another stream.
    /// - Parameter destination: The stream to which the contents of the current stream will be copied.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    func copyToAsync(destination: Stream) async throws
    
    /// Asynchronously reads all bytes from the current stream and writes them to another stream using the specified buffer size.
    /// - Parameters:
    ///   - destination: The stream to which the contents of the current stream will be copied.
    ///   - bufferSize: The size of the buffer to use for copying.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    func copyToAsync(destination: Stream, bufferSize: Int) async throws
    
    /// Clears all buffers for this stream and causes any buffered data to be written to the underlying device.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    func flush() throws
    
    /// Asynchronously clears all buffers for this stream and causes any buffered data to be written to the underlying device.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    func flushAsync() async throws
    
    /// Reads a sequence of bytes from the current stream and advances the position within the stream by the number of bytes read.
    /// - Parameters:
    ///   - buffer: The buffer to read the data into.
    ///   - offset: The byte offset in buffer at which to begin storing the data read from the stream.
    ///   - count: The maximum number of bytes to be read from the stream.
    /// - Returns: The total number of bytes read into the buffer. This can be less than the number of bytes requested if that many bytes are not currently available, or zero if the end of the stream has been reached.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    func read(buffer: inout Data, offset: Int, count: Int) throws -> Int
    
    /// Asynchronously reads a sequence of bytes from the current stream and advances the position within the stream by the number of bytes read.
    /// - Parameters:
    ///   - buffer: The buffer to read the data into.
    ///   - offset: The byte offset in buffer at which to begin storing the data read from the stream.
    ///   - count: The maximum number of bytes to be read from the stream.
    /// - Returns: The total number of bytes read into the buffer.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    func readAsync(buffer: inout Data, offset: Int, count: Int) async throws -> Int
    
    /// Reads a byte from the stream and advances the position within the stream by one byte.
    /// - Returns: The unsigned 8-bit integer read from the stream.
    /// - Throws: `SwiftIOError.endOfStream` if the end of the stream is reached, or other `SwiftIOError` if an I/O error occurs.
    func readByte() throws -> UInt8
    
    /// Sets the position within the current stream.
    /// - Parameters:
    ///   - offset: A byte offset relative to the origin parameter.
    ///   - origin: A value of type `SeekOrigin` indicating the reference point used to obtain the new position.
    /// - Returns: The new position within the stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    func seek(offset: Int, origin: SeekOrigin) throws -> Int
    
    /// Sets the length of the current stream.
    /// - Parameter length: The desired length of the current stream in bytes.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    func setLength(length: Int) throws
    
    /// Writes a sequence of bytes to the current stream and advances the current position within this stream by the number of bytes written.
    /// - Parameters:
    ///   - buffer: An array of bytes. This method copies count bytes from buffer to the current stream.
    ///   - offset: The zero-based byte offset in buffer at which to begin copying bytes to the current stream.
    ///   - count: The number of bytes to be written to the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    func write(buffer: Data, offset: Int, count: Int) throws
    
    /// Asynchronously writes a sequence of bytes to the current stream and advances the current position within this stream by the number of bytes written.
    /// - Parameters:
    ///   - buffer: An array of bytes. This method copies count bytes from buffer to the current stream.
    ///   - offset: The zero-based byte offset in buffer at which to begin copying bytes to the current stream.
    ///   - count: The number of bytes to be written to the current stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    func writeAsync(buffer: Data, offset: Int, count: Int) async throws
    
    /// Writes a byte to the current position in the stream and advances the position within the stream by one byte.
    /// - Parameter byte: The byte to write to the stream.
    /// - Throws: `SwiftIOError` if an I/O error occurs.
    func writeByte(byte: UInt8) throws
    
    // MARK: - Result callback versions (non-throwing)
    
    /// Reads all bytes from the current stream and writes them to another stream using a completion callback.
    /// - Parameters:
    ///   - destination: The stream to which the contents of the current stream will be copied.
    ///   - completion: A completion handler that receives a `Result` indicating success or failure.
    func copyTo(destination: Stream, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    
    /// Reads all bytes from the current stream and writes them to another stream using the specified buffer size and a completion callback.
    /// - Parameters:
    ///   - destination: The stream to which the contents of the current stream will be copied.
    ///   - bufferSize: The size of the buffer to use for copying.
    ///   - completion: A completion handler that receives a `Result` indicating success or failure.
    func copyTo(destination: Stream, bufferSize: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    
    /// Asynchronously reads all bytes from the current stream and writes them to another stream using a completion callback.
    /// - Parameters:
    ///   - destination: The stream to which the contents of the current stream will be copied.
    ///   - completion: A completion handler that receives a `Result` indicating success or failure.
    func copyToAsync(destination: Stream, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    
    /// Asynchronously reads all bytes from the current stream and writes them to another stream using the specified buffer size and a completion callback.
    /// - Parameters:
    ///   - destination: The stream to which the contents of the current stream will be copied.
    ///   - bufferSize: The size of the buffer to use for copying.
    ///   - completion: A completion handler that receives a `Result` indicating success or failure.
    func copyToAsync(destination: Stream, bufferSize: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    
    /// Clears all buffers for this stream using a completion callback.
    /// - Parameter completion: A completion handler that receives a `Result` indicating success or failure.
    func flush(completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    
    /// Asynchronously clears all buffers for this stream using a completion callback.
    /// - Parameter completion: A completion handler that receives a `Result` indicating success or failure.
    func flushAsync(completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    
    /// Reads a sequence of bytes from the current stream using a completion callback.
    /// - Parameters:
    ///   - buffer: The buffer to read the data into.
    ///   - offset: The byte offset in buffer at which to begin storing the data read from the stream.
    ///   - count: The maximum number of bytes to be read from the stream.
    ///   - completion: A completion handler that receives a `Result` containing the number of bytes read, or an error.
    func read(buffer: inout Data, offset: Int, count: Int, completion: @escaping (Result<Int, SwiftIOError>) -> Void)
    
    /// Asynchronously reads a sequence of bytes from the current stream using a completion callback.
    /// - Parameters:
    ///   - buffer: The buffer to read the data into.
    ///   - offset: The byte offset in buffer at which to begin storing the data read from the stream.
    ///   - count: The maximum number of bytes to be read from the stream.
    ///   - completion: A completion handler that receives a `Result` containing the number of bytes read, or an error.
    func readAsync(buffer: inout Data, offset: Int, count: Int, completion: @escaping (Result<Int, SwiftIOError>) -> Void)
    
    /// Reads a byte from the stream using a completion callback.
    /// - Parameter completion: A completion handler that receives a `Result` containing the byte read, or an error.
    func readByte(completion: @escaping (Result<UInt8, SwiftIOError>) -> Void)
    
    /// Sets the position within the current stream using a completion callback.
    /// - Parameters:
    ///   - offset: A byte offset relative to the origin parameter.
    ///   - origin: A value of type `SeekOrigin` indicating the reference point used to obtain the new position.
    ///   - completion: A completion handler that receives a `Result` containing the new position, or an error.
    func seek(offset: Int, origin: SeekOrigin, completion: @escaping (Result<Int, SwiftIOError>) -> Void)
    
    /// Sets the length of the current stream using a completion callback.
    /// - Parameters:
    ///   - length: The desired length of the current stream in bytes.
    ///   - completion: A completion handler that receives a `Result` indicating success or failure.
    func setLength(length: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    
    /// Writes a sequence of bytes to the current stream using a completion callback.
    /// - Parameters:
    ///   - buffer: An array of bytes. This method copies count bytes from buffer to the current stream.
    ///   - offset: The zero-based byte offset in buffer at which to begin copying bytes to the current stream.
    ///   - count: The number of bytes to be written to the current stream.
    ///   - completion: A completion handler that receives a `Result` indicating success or failure.
    func write(buffer: Data, offset: Int, count: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    
    /// Asynchronously writes a sequence of bytes to the current stream using a completion callback.
    /// - Parameters:
    ///   - buffer: An array of bytes. This method copies count bytes from buffer to the current stream.
    ///   - offset: The zero-based byte offset in buffer at which to begin copying bytes to the current stream.
    ///   - count: The number of bytes to be written to the current stream.
    ///   - completion: A completion handler that receives a `Result` indicating success or failure.
    func writeAsync(buffer: Data, offset: Int, count: Int, completion: @escaping (Result<Void, SwiftIOError>) -> Void)
    
    /// Writes a byte to the current position in the stream using a completion callback.
    /// - Parameters:
    ///   - byte: The byte to write to the stream.
    ///   - completion: A completion handler that receives a `Result` indicating success or failure.
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