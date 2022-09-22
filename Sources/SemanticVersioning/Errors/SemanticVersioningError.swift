public enum SemanticVersioningError: Error {
    case empty
    case containsInvalidCharacter
    case invalidFormat
}

public enum PreReleaseError: Error, CustomStringConvertible {
    case empty
    case invalidCharacter
    case leadingZero

    public var description: String {
        switch self {
        case .empty:
            return "pre-release identifiers MUST NOT be empty"
        case .invalidCharacter:
            return "pre-release identifiers must not "
        case .leadingZero:
            return "pre-release numeric identifiers MUST NOT include leading zeroes."
        }
    }
}
