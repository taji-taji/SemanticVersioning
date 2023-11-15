public enum SemanticVersioningParseError: Error, CustomStringConvertible {
    case versionNumberMustTakeTheFromXYZ
    case majorMustNotContainLeadingZeros
    case majorMustNonNegativeIntegers
    case minorMustNotContainLeadingZeros
    case minorMustNonNegativeIntegers
    case patchMustNotContainLeadingZeros
    case patchMustNonNegativeIntegers
    case preReleaseIdentifierMustNotEmpty
    case preReleaseContainsInvalidCharacter
    case preReleaseNumericIdentifierMustNotContainLeadingZeros
    case buildMetaDataIdentifierMustNotEmpty
    case buildMetaDataContainsInvalidCharacter

    public var description: String {
        switch self {
        case .versionNumberMustTakeTheFromXYZ:
            return """
            A normal version number MUST take the form X.Y.Z.
            Ref: https://semver.org/#spec-item-2
            """
        case .majorMustNotContainLeadingZeros:
            return """
            Major version MUST NOT contain leading zeroes.
            Ref: https://semver.org/#spec-item-2
            """
        case .majorMustNonNegativeIntegers:
            return """
            Major version MUST non-negative integers.
            Ref: https://semver.org/#spec-item-2
            """
        case .minorMustNotContainLeadingZeros:
            return """
            Minor version MUST NOT contain leading zeroes.
            Ref: https://semver.org/#spec-item-2
            """
        case .minorMustNonNegativeIntegers:
            return """
            Minor version MUST non-negative integers.
            Ref: https://semver.org/#spec-item-2
            """
        case .patchMustNotContainLeadingZeros:
            return """
            Patch version MUST NOT contain leading zeroes.
            Ref: https://semver.org/#spec-item-2
            """
        case .patchMustNonNegativeIntegers:
            return """
            Patch version MUST non-negative integers.
            Ref: https://semver.org/#spec-item-2
            """
        case .preReleaseIdentifierMustNotEmpty:
            return """
            Pre-release identifiers MUST NOT be empty.
            Ref: https://semver.org/#spec-item-9
            """
        case .preReleaseContainsInvalidCharacter:
            return """
            Pre-release identifiers MUST comprise only ASCII alphanumerics and hyphens [0-9A-Za-z-].
            Ref: https://semver.org/#spec-item-9
            """
        case .preReleaseNumericIdentifierMustNotContainLeadingZeros:
            return """
            Pre-release numeric identifiers MUST NOT include leading zeroes.
            Ref: https://semver.org/#spec-item-9
            """
        case .buildMetaDataIdentifierMustNotEmpty:
            return """
            Build metadata identifiers MUST NOT be empty.
            Ref: https://semver.org/#spec-item-10
            """
        case .buildMetaDataContainsInvalidCharacter:
            return """
            Build metadata identifiers MUST comprise only ASCII alphanumerics and hyphens [0-9A-Za-z-].
            Ref: https://semver.org/#spec-item-10
            """
        }
    }
}
