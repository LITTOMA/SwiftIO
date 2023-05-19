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

### BinaryPrimitives

The `BinaryPrimitives` interface in SwiftIO provides methods for reading and writing basic data types in binary form. Let's take a look at a couple of test cases as examples:

**Reading a double value in big-endian format:**

```swift
import SwiftIO

let bytes: [UInt8] = [0x3F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
let data = Data(bytes)
let value = BinaryPrimitives.readDoubleBigEndian(from: data)
print(value) // Output: 1.0
```

In this example, we have a byte array representing a double value in big-endian format. We convert it to a `Data` object and use the `readDoubleBigEndian` method from `BinaryPrimitives` to read the value. The resulting `value` will be 1.0.

**Reading a double value in little-endian format:**

```swift
import SwiftIO

let bytes: [UInt8] = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F]
let data = Data(bytes)
let value = BinaryPrimitives.readDoubleLittleEndian(from: data)
print(value) // Output: 1.0
```

Similarly, in this example, we have a byte array representing a double value in little-endian format. We convert it to a `Data` object and use the `readDoubleLittleEndian` method from `BinaryPrimitives` to read the value. The resulting `value` will also be 1.0.

Please note that in your actual code, you may need to import the SwiftIO module and adapt the test cases based on your specific requirements.

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
