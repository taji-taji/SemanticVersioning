public enum SemanticVersioningParseError: Error, CustomStringConvertible {
    case empty
    case containsInvalidCharacter
    case invalidFormat

    public var description: String {
        switch self {
        case .empty:
            return """
                   Semantic Versioning MUST NOT be empty.
                   Ref: https://semver.org/#spec-item-2
                   """
        case .containsInvalidCharacter:
            return """
                   Normal version number MUST take the form X.Y.Z where X, Y, and Z are non-negative integers.
                   And pre-release identifiers MUST comprise only ASCII alphanumerics and hyphens [0-9A-Za-z-],
                   Build metadata identifiers MUST comprise only ASCII alphanumerics and hyphens [0-9A-Za-z-].
                   Ref: https://semver.org/#spec-item-2, https://semver.org/#spec-item-9, https://semver.org/#spec-item-10
                   """
        case .invalidFormat:
            return """
                   A normal version number MUST take the form X.Y.Z where X, Y, and Z are non-negative integers, and MUST NOT contain leading zeroes.
                   Ref: https://semver.org/#spec-item-2
                   """
        }
    }
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
