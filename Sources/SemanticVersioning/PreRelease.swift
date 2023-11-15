public struct PreRelease: CustomStringConvertible {
    public let identifiers: [Identifier]
    public var description: String {
        identifiers.map(\.description).joined(separator: ".")
    }

    public init(from string: String) throws {
        identifiers = try string
                .split(separator: ".")
                .map { try Identifier(from: String($0)) }
    }
}

extension PreRelease: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        do {
            self = try PreRelease(from: value)
        } catch let error as PreReleaseParseError {
            fatalError("""
                       pre-release parse failed. input: \(value)
                       \(error.description)
                       """)
        } catch {
            fatalError("""
                       pre-release parse failed. input: \(value)
                       """)
        }
    }
}

extension PreRelease: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        let lComponents = lhs.identifiers
        let rComponents = rhs.identifiers
        for (lComponent, rComponent) in zip(lComponents, rComponents) {
            if lComponent == rComponent {
                continue
            }
            return lComponent < rComponent
        }
        return lComponents.count < rComponents.count
    }
}

extension PreRelease {
    public enum Identifier: Comparable, CustomStringConvertible {
        case int(Int)
        case asciiOrHyphen(String)

        public var description: String {
            switch self {
            case let .int(value):
                return "\(value)"
            case let .asciiOrHyphen(value):
                return value
            }
        }

        init(from string: String) throws {
            guard !string.isEmpty else {
                throw PreReleaseParseError.empty
            }
            guard string.allSatisfy({ $0.isASCII || $0 == "-" }) else {
                throw PreReleaseParseError.invalidCharacter
            }
            if let intValue = Int(string) {
                guard string.first != "0" else {
                    throw PreReleaseParseError.leadingZero
                }
                self = .int(intValue)
            } else {
                self = .asciiOrHyphen(string)
            }
        }

        public static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.int(lIntValue), .int(rIntValue)):
                return lIntValue < rIntValue
            case (.int, .asciiOrHyphen):
                return true
            case (.asciiOrHyphen, .int):
                return false
            case let (.asciiOrHyphen(lAsciiOrHyphen), .asciiOrHyphen(rAsciiOrHyphen)):
                return lAsciiOrHyphen < rAsciiOrHyphen
            }
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
