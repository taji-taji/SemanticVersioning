import SemanticVersioning

extension SemanticVersioning {
    public var shortVersionString: String {
        guard preRelease == nil, buildMetaData == nil else { return versionString }

        switch (minor, patch) {
        case let (minor, 0) where minor > 0:
            return "\(major).\(minor)"
        case (0, 0):
            return "\(major)"
        default:
            return versionString
        }
    }

    public func versionString(withPrefix prefix: String) -> String {
        prefix + versionString
    }
}
