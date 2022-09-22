import Foundation

enum SemanticVersioningParser {
    static func parse<V: SemanticVersioning>(from string: String) throws -> V {
        guard !string.isEmpty else {
            throw SemanticVersioningParseError.empty
        }
        guard string.allSatisfy({ $0.isASCII || $0 == "-" }) else {
            throw SemanticVersioningParseError.containsInvalidCharacter
        }

        // ref: https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
        let capturePattern = #"^(?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)(?:-(?<prerelease>(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$"#
        let range = NSRange(string.startIndex ..< string.endIndex, in: string)
        let captureRegex = try NSRegularExpression(pattern: capturePattern, options: [])
        let matches = captureRegex.matches(in: string, options: [], range: range)

        guard let match = matches.first else {
            throw SemanticVersioningParseError.invalidFormat
        }
        var captures: [String: String] = [:]

        for name in ["major", "minor", "patch", "prerelease", "buildmetadata"] {
            let matchRange = match.range(withName: name)

            if let substringRange = Range(matchRange, in: string) {
                let capture = String(string[substringRange])
                captures[name] = capture
            }
        }

        guard let majorString = captures["major"],
              let minorString = captures["minor"],
              let patchString = captures["patch"] else {
            throw SemanticVersioningParseError.invalidFormat
        }

        let preRelease: PreRelease? = try { () throws -> PreRelease? in
            if let preReleaseString = captures["prerelease"] {
                return try PreRelease(from: preReleaseString)
            } else {
                return nil
            }
        }()

        return V.init(major: Int(majorString)!,
                      minor: Int(minorString)!,
                      patch: Int(patchString)!,
                      preRelease: preRelease,
                      buildMetaData: captures["buildmetadata"])
    }
}
