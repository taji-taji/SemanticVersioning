import Foundation
import SemanticVersioning

extension OperatingSystemVersion: SemanticVersioning {
    public var major: Int { majorVersion }
    public var minor: Int { minorVersion }
    public var patch: Int { patchVersion }
    public var preRelease: PreRelease? { nil }
    public var buildMetaData: String? { nil }

    public init(major: Int,
                minor: Int,
                patch: Int,
                preRelease: PreRelease?,
                buildMetaData: String?) {
        self.init(majorVersion: major, minorVersion: minor, patchVersion: patch)
    }
}
