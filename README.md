SwiftIO
=======

SwiftIO is a library that aims to provide similar functionality to the System.IO namespace in .NET for developers transitioning from .NET to Swift. It offers interfaces such as BinaryPrimitives, FileStream, MemoryStream, Binary Reader/Writer, and Encoding, allowing developers to work with IO operations in a familiar way.

Purpose
-------

The main purpose of SwiftIO is to ease the transition for developers familiar with System.IO in .NET. By providing similar interfaces and functionality, SwiftIO allows developers to leverage their existing knowledge and easily adapt to IO operations in Swift.

Features
--------

*   **BinaryPrimitives**: Provides methods for reading and writing basic data types in binary form, similar to the BinaryPrimitives class in .NET.
*   **FileStream**: Allows reading from and writing to files using familiar stream-based operations.
*   **MemoryStream**: Enables in-memory stream operations for reading from and writing to byte arrays.
*   **Binary Reader/Writer**: Provides functionality for reading and writing binary data, similar to the BinaryReader and BinaryWriter classes in .NET.
*   **Encoding**: Offers encoding and decoding capabilities for various character encodings, facilitating text-based IO operations.

Please note that the IO implementation in this repository focuses on providing usage patterns similar to System.IO, rather than optimizing for IO performance. Users are advised to evaluate their specific requirements and decide whether to utilize this library accordingly.

Getting Started
---------------

To use SwiftIO in your Swift project, follow these steps:

1.  Clone the repository:
    
    ```bash
    git clone https://github.com/LITTOMA/SwiftIO.git
    ```
    
2.  Add the SwiftIO files to your project.
    
3.  Import the SwiftIO module in your Swift file:
    
    ```swift
    import SwiftIO
    ```
    
4.  You're ready to start using the provided IO interfaces and classes in your code.
    

Examples
--------

Here are a few examples to demonstrate how to use SwiftIO:

**Reading from a file using FileStream:**

```swift
import SwiftIO

let fileStream = try FileStream(path: "path/to/file.txt", mode: .read)
let data = try fileStream.read()
print(data)
fileStream.close()
```

**Writing to a file using FileStream:**

```swift
import SwiftIO

let fileStream = try FileStream(path: "path/to/file.txt", mode: .write)
let data = "Hello, SwiftIO!"
try fileStream.write(data)
fileStream.close()
```

**Reading from a byte array using MemoryStream:**

```swift
import SwiftIO

let byteArray: [UInt8] = [0x48, 0x65, 0x6c, 0x6c, 0x6f] // Hello
let memoryStream = try MemoryStream(data: byteArray)
let data = try memoryStream.read()
print(data)
memoryStream.close()
```

**Writing to a byte array using MemoryStream:**

```swift
import SwiftIO

var byteArray: [UInt8] = []
let memoryStream = try MemoryStream(data: &byteArray)
let data = "Hello, SwiftIO!".data(using: .utf8)!
try memoryStream.write(data)
memoryStream.close()
print(byteArray)
```

For more detailed examples and usage instructions, please refer to the [documentation](https://github.com/LITTOMA/SwiftIO/wiki).

Contributing
------------

Contributions to SwiftIO are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request. Make sure to follow the [contribution guidelines](CONTRIBUTING.md) when contributing.

License
-------

This project is licensed under the [MIT License](LICENSE).

* * *

We hope SwiftIO helps simplify your transition from .NET to Swift and provides a familiar IO experience. If you have any questions or need further assistance, please feel free to reach out to us.

Happy coding!
