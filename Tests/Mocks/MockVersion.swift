import Foundation
import SemanticVersioning

public struct MockVersion: SemanticVersioning {
    public let major: Int
    public let minor: Int
    public let patch: Int
    public let preRelease: PreRelease?
    public let buildMetaData: String?

    public init(major: Int, minor: Int, patch: Int, preRelease: PreRelease?, buildMetaData: String?) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.preRelease = preRelease
        self.buildMetaData = buildMetaData
    }
}
