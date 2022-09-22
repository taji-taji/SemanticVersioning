public enum SemanticVersioningParseError: Error {
    case empty
    case containsInvalidCharacter
    case invalidFormat
}

public enum PreReleaseParseError: Error, CustomStringConvertible {
    case empty
    case invalidCharacter
    case leadingZero

    public var description: String {
        switch self {
        case .empty:
            return """
                   pre-release identifiers MUST NOT be empty.
                   Ref: https://semver.org/#spec-item-9
                   """
        case .invalidCharacter:
            return """
                   pre-release identifiers MUST comprise only ASCII alphanumerics and hyphens [0-9A-Za-z-].
                   Ref: https://semver.org/#spec-item-9
                   """
        case .leadingZero:
            return """
                   pre-release numeric identifiers MUST NOT include leading zeroes.
                   Ref: https://semver.org/#spec-item-9
                   """
        }
    }
}
