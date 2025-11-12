public enum Endianess { 
    case big, little
}

public enum BinaryStringFormat { 
    case zeroTerminated, bytePrefixLength, uint16PrefixLength, uint32PrefixLength, uint64PrefixLength
}

public enum FileMode : Int32 {
    case createNew = 1, create, open, openOrCreate, truncate, append
}

public enum SeekOrigin : Int32 {
    case begin = 0, current, end
}