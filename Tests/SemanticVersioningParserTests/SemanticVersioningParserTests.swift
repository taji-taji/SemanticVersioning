import Foundation
import XCTest
@testable import SemanticVersioningParser

final class SemanticVersioningParserTests: XCTestCase {
    typealias SemanticVersioningComponents = (Int, Int, Int, String?, String?)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testParseSuccessWithValidVersionString() throws {
        let validVersionsTable: [String: SemanticVersioningComponents] = [
            "0.0.4": (0, 0, 4, nil, nil),
            "1.2.3": (1, 2, 3, nil, nil),
            "10.20.30": (10, 20, 30, nil, nil),
            "1.1.2-prerelease+meta": (1, 1, 2, "prerelease", "meta"),
            "1.1.2+meta": (1, 1, 2, nil, "meta"),
            "1.1.2+meta-valid": (1, 1, 2, nil, "meta-valid"),
            "1.0.0-alpha": (1, 0, 0, "alpha", nil),
            "1.0.0-beta": (1, 0, 0, "beta", nil),
            "1.0.0-alpha.beta": (1, 0, 0, "alpha.beta", nil),
            "1.0.0-alpha.beta.1": (1, 0, 0, "alpha.beta.1", nil),
            "1.0.0-alpha.1": (1, 0, 0, "alpha.1", nil),
            "1.0.0-alpha0.valid": (1, 0, 0, "alpha0.valid", nil),
            "1.0.0-alpha.0valid": (1, 0, 0, "alpha.0valid", nil),
            "1.0.0-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay": (1, 0, 0, "alpha-a.b-c-somethinglong", "build.1-aef.1-its-okay"),
            "1.0.0-rc.1+build.1": (1, 0, 0, "rc.1", "build.1"),
            "2.0.0-rc.1+build.123": (2, 0, 0, "rc.1", "build.123"),
            "1.2.3-beta": (1, 2, 3, "beta", nil),
            "10.2.3-DEV-SNAPSHOT": (10, 2, 3, "DEV-SNAPSHOT", nil),
            "1.2.3-SNAPSHOT-123": (1, 2, 3, "SNAPSHOT-123", nil),
            "1.0.0": (1, 0, 0, nil, nil),
            "2.0.0": (2, 0, 0, nil, nil),
            "1.1.7": (1, 1, 7, nil, nil),
            "2.0.0+build.1848": (2, 0, 0, nil, "build.1848"),
            "2.0.1-alpha.1227": (2, 0, 1, "alpha.1227", nil),
            "1.0.0-alpha+beta": (1, 0, 0, "alpha", "beta"),
            "1.2.3----RC-SNAPSHOT.12.9.1--.12+788": (1, 2, 3, "---RC-SNAPSHOT.12.9.1--.12", "788"),
            "1.2.3----R-S.12.9.1--.12+meta": (1, 2, 3, "---R-S.12.9.1--.12", "meta"),
            "1.2.3----RC-SNAPSHOT.12.9.1--.12": (1, 2, 3, "---RC-SNAPSHOT.12.9.1--.12", nil),
            "1.0.0+0.build.1-rc.10000aaa-kk-0.1": (1, 0, 0, nil, "0.build.1-rc.10000aaa-kk-0.1"),
            "999999999999999999.999999999999999999.99999999999999999": (999999999999999999, 999999999999999999, 99999999999999999, nil, nil),
            "1.0.0-0A.is.legal": (1, 0, 0, "0A.is.legal", nil),
        ]
        
        for (input, expected) in validVersionsTable {
            let result = try SemanticVersioningParser.parse(from: input)
            print(result, expected)
            XCTAssertEqual(result.major, expected.0)
            XCTAssertEqual(result.minor, expected.1)
            XCTAssertEqual(result.patch, expected.2)
            XCTAssertEqual(result.preRelease, expected.3)
            XCTAssertEqual(result.buildMetaData, expected.4)
        }
    }
    
    func testParseFailureWithInvalidVersionString() throws {
        let invalidVersionsTable: [String: SemanticVersioningParseError] = [
            "1": .versionNumberMustTakeTheFromXYZ,
            "1.2": .versionNumberMustTakeTheFromXYZ,
            "1.2.3-0123": .preReleaseNumericIdentifierMustNotContainLeadingZeros,
            "1.2.3-0123.0123": .preReleaseNumericIdentifierMustNotContainLeadingZeros,
            "1.1.2+.123": .buildMetaDataIdentifierMustNotEmpty,
            "+invalid": .versionNumberMustTakeTheFromXYZ,
            "-invalid": .versionNumberMustTakeTheFromXYZ,
            "-invalid+invalid": .versionNumberMustTakeTheFromXYZ,
            "-invalid.01": .versionNumberMustTakeTheFromXYZ,
            "alpha": .versionNumberMustTakeTheFromXYZ,
            "alpha.beta": .versionNumberMustTakeTheFromXYZ,
            "alpha.beta.1": .majorMustNonNegativeIntegers,
            "alpha.1": .versionNumberMustTakeTheFromXYZ,
            "alpha+beta": .versionNumberMustTakeTheFromXYZ,
            "alpha_beta": .versionNumberMustTakeTheFromXYZ,
            "alpha.": .versionNumberMustTakeTheFromXYZ,
            "alpha..": .versionNumberMustTakeTheFromXYZ,
            "beta": .versionNumberMustTakeTheFromXYZ,
            "1.0.0-alpha_beta": .preReleaseContainsInvalidCharacter,
            "-alpha.": .versionNumberMustTakeTheFromXYZ,
            "1.0.0-alpha..": .preReleaseIdentifierMustNotEmpty,
            "1.0.0-alpha..1": .preReleaseIdentifierMustNotEmpty,
            "1.0.0-alpha...1": .preReleaseIdentifierMustNotEmpty,
            "1.0.0-alpha....1": .preReleaseIdentifierMustNotEmpty,
            "1.0.0-alpha.....1": .preReleaseIdentifierMustNotEmpty,
            "1.0.0-alpha......1": .preReleaseIdentifierMustNotEmpty,
            "1.0.0-alpha.......1": .preReleaseIdentifierMustNotEmpty,
            "01.1.1": .majorMustNotContainLeadingZeros,
            "1.01.1": .minorMustNotContainLeadingZeros,
            "1.1.01": .patchMustNotContainLeadingZeros,
            "1.2.3.DEV": .patchMustNonNegativeIntegers,
            "1.2-SNAPSHOT": .versionNumberMustTakeTheFromXYZ,
            "1.2.31.2.3----RC-SNAPSHOT.12.09.1--..12+788": .patchMustNonNegativeIntegers,
            "1.2-RC-SNAPSHOT": .versionNumberMustTakeTheFromXYZ,
            "-1.0.3-gamma+b7718": .majorMustNonNegativeIntegers,
            "+justmeta": .versionNumberMustTakeTheFromXYZ,
            "9.8.7+meta+meta": .buildMetaDataContainsInvalidCharacter,
            "9.8.7-whatever+meta+meta": .buildMetaDataContainsInvalidCharacter,
            "999999999999999999.999999999999999999.999999999999999999----RC-SNAPSHOT.12.09.1--------------------------------..12": .preReleaseIdentifierMustNotEmpty,
        ]
        
        for (version, parseError) in invalidVersionsTable {
            print("----: \(version)")
            XCTAssertThrowsError(try SemanticVersioningParser.parse(from: version)) { error in
                do {
                    let error = try XCTUnwrap(error as? SemanticVersioningParseError)
                    XCTAssertEqual(error, parseError)
                } catch {
                    XCTFail()
                }
            }
        }
    }
}
