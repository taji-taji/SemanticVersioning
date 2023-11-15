import Foundation

package enum SemanticVersioningParser {
    package static func parse(from string: String) throws -> (major: Int,
                                                              minor: Int,
                                                              patch: Int,
                                                              preRelease: String?,
                                                              buildMetaData: String?) {
        // check `X.Y.Z` form
        let dotSplitted = string
            .split(separator: ".", omittingEmptySubsequences: false)
            .map(String.init)
        guard dotSplitted.count >= 3, dotSplitted.prefix(3).allSatisfy(\.hasCharacter) else {
            throw SemanticVersioningParseError.versionNumberMustTakeTheFromXYZ
        }
        
        let majorString = dotSplitted[0]
        let minorString = dotSplitted[1]
        
        var patchAndMore = dotSplitted
            .dropFirst(2) // drop major, minor
            .joined(separator: ".") // patch and prerelease and build metadata. prerelease and metadata may contains `.` string

        // extract build metadata
        let buildMetaData: String?
        if let plusSignIndex = patchAndMore.firstIndex(of: "+") {
            buildMetaData = String(patchAndMore.suffix(from: plusSignIndex).dropFirst()) // drop first `+` sign.
            patchAndMore = String(patchAndMore.prefix(upTo: plusSignIndex))
        } else {
            buildMetaData = nil
        }
        
        // extract prerelease
        let preRelease: String?
        if let minusSignIndex = patchAndMore.firstIndex(of: "-") {
            preRelease = String(patchAndMore.suffix(from: minusSignIndex).dropFirst()) // drop first `-` sign.
            patchAndMore = String(patchAndMore.prefix(upTo: minusSignIndex))
        } else {
            preRelease = nil
        }
        
        let patchString = patchAndMore
        
        guard let major = UInt(majorString) else {
            throw SemanticVersioningParseError.majorMustNonNegativeIntegers
        }
        
        if majorString.hasLeadingZeros {
            throw SemanticVersioningParseError.majorMustNotContainLeadingZeros
        }
        
        guard let minor = UInt(minorString) else {
            throw SemanticVersioningParseError.minorMustNonNegativeIntegers
        }
        
        if minorString.hasLeadingZeros {
            throw SemanticVersioningParseError.minorMustNotContainLeadingZeros
        }
        
        guard let patch = UInt(patchString) else {
            throw SemanticVersioningParseError.patchMustNonNegativeIntegers
        }
        
        if patchString.hasLeadingZeros {
            throw SemanticVersioningParseError.patchMustNotContainLeadingZeros
        }

        if let preRelease = preRelease {
            let identifiers = preRelease
                .split(separator: ".", omittingEmptySubsequences: false)
                .map(String.init)
            guard identifiers.allSatisfy(\.hasCharacter) else {
                throw SemanticVersioningParseError.preReleaseIdentifierMustNotEmpty
            }
            
            for identifier in identifiers {
                guard identifier.unicodeScalars.allSatisfy({ CharacterSet.alphanumerics.contains($0) || String($0) == "-" }) else {
                    throw SemanticVersioningParseError.preReleaseContainsInvalidCharacter
                }
                
                if identifier.isAllNumeric, identifier.count > 1, identifier.starts(with: "0") {
                    throw SemanticVersioningParseError.preReleaseNumericIdentifierMustNotContainLeadingZeros
                }
            }
        }
        
        if let buildMetaData = buildMetaData {
            let identifiers = buildMetaData
                .split(separator: ".", omittingEmptySubsequences: false)
                .map(String.init)
            guard identifiers.allSatisfy(\.hasCharacter) else {
                throw SemanticVersioningParseError.buildMetaDataIdentifierMustNotEmpty
            }
            
            for identifier in identifiers {
                guard identifier.unicodeScalars.allSatisfy({ CharacterSet.alphanumerics.contains($0) || String($0) == "-" }) else {
                    throw SemanticVersioningParseError.buildMetaDataContainsInvalidCharacter
                }
            }
        }

        return (major: Int(major),
                minor: Int(minor),
                patch: Int(patch),
                preRelease: preRelease,
                buildMetaData: buildMetaData)
    }
}

private extension String {
    var hasCharacter: Bool {
        !isEmpty
    }
    
    var isAllNumeric: Bool {
        allSatisfy({ Int(String($0)) != nil })
    }
    
    var hasLeadingZeros: Bool {
        count > 1 && starts(with: "0")
    }
}
