import Foundation

public protocol SemanticVersioning: Comparable, CustomStringConvertible, ExpressibleByStringLiteral where StringLiteralType == String, UnicodeScalarLiteralType == String, ExtendedGraphemeClusterLiteralType == String {
    var major: Int { get }
    var minor: Int { get }
    var patch: Int { get }
    var preRelease: PreRelease? { get }
    var buildMetaData: String? { get }

    init(major: Int, minor: Int, patch: Int, preRelease: PreRelease?, buildMetaData: String?)
}

extension SemanticVersioning {
    public var versionString: String {
        let basicElements = [
            String(major),
            String(minor),
            String(patch),
        ]
        let optionalElements = [
            preRelease == nil ? nil : "-\(preRelease!.description)",
            buildMetaData == nil ? nil : "+\(buildMetaData!)",
        ]

        return basicElements.joined(separator: ".")
            + optionalElements.compactMap({ $0 }).joined()
    }
    public var description: String { versionString }

    public func increment(_ element: SemanticVersioningElement) -> Self {
        switch element {
        case .major:
            return .init(major: major + 1, minor: 0, patch: 0)
        case .minor:
            return .init(major: major, minor: minor + 1, patch: 0)
        case .patch:
            return .init(major: major, minor: minor, patch: patch + 1)
        }
    }
}

extension SemanticVersioning {
    public init(major: Int, minor: Int, patch: Int) {
        self.init(major: major, minor: minor, patch: patch, preRelease: nil, buildMetaData: nil)
    }

    public init(from string: String) throws {
        self = try SemanticVersioningParser.parse(from: string)
    }

    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(stringLiteral: value)
    }

    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(stringLiteral: value)
    }

    public init(stringLiteral value: StringLiteralType) {
        do {
            try self.init(from: value)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

extension SemanticVersioning {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        let lElements = [lhs.major, lhs.minor, lhs.patch]
        let rElements = [rhs.major, rhs.minor, rhs.patch]
        if lElements != rElements {
            return lElements.lexicographicallyPrecedes(rElements)
        }

        switch (lhs.preRelease, rhs.preRelease) {
        case (.none, .none):
            return false
        case (.some, .none):
            return true
        case (.none, .some):
            return false
        case let (.some(lPreRelease), .some(rPreRelease)):
            return lPreRelease < rPreRelease
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.major == rhs.major
            && lhs.minor == rhs.minor
            && lhs.patch == rhs.patch
            && lhs.preRelease == rhs.preRelease
    }
}
