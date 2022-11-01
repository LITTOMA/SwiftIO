enum Endianess { 
    case big, little
}

enum BinaryStringFormat { 
    case zeroTerminated, bytePrefixLength, uint16PrefixLength, uint32PrefixLength, uint64PrefixLength
}

enum FileMode : Int32 {
    case createNew = 1, create, open, openOrCreate, truncate, append
}

enum SeekOrigin : Int32 {
    case begin = 0, current, end
}