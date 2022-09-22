import Mocks
import XCTest
@testable import SemanticVersioning

final class SemanticVersioningTests: XCTestCase {
    func testInit() throws {
        XCTAssertEqual(MockVersion(major: 1, minor: 1, patch: 1), "1.1.1")
        XCTAssertEqual(MockVersion(major: 1, minor: 2, patch: 3, preRelease: "alpha", buildMetaData: nil), "1.2.3-alpha")
        XCTAssertEqual(MockVersion(major: 1, minor: 2, patch: 3, preRelease: "alpha.1.2", buildMetaData: nil), "1.2.3-alpha.1.2")
        XCTAssertEqual(MockVersion(major: 1, minor: 2, patch: 3, preRelease: "alpha.1.2", buildMetaData: "build.1"), "1.2.3-alpha.1.2+build.1")
    }

    func testInitFromStringValidVersions() throws {
        let validVersions = [
            "0.0.4",
            "1.2.3",
            "10.20.30",
            "1.1.2-prerelease+meta",
            "1.1.2+meta",
            "1.1.2+meta-valid",
            "1.0.0-alpha",
            "1.0.0-beta",
            "1.0.0-alpha.beta",
            "1.0.0-alpha.beta.1",
            "1.0.0-alpha.1",
            "1.0.0-alpha0.valid",
            "1.0.0-alpha.0valid",
            "1.0.0-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay",
            "1.0.0-rc.1+build.1",
            "2.0.0-rc.1+build.123",
            "1.2.3-beta",
            "10.2.3-DEV-SNAPSHOT",
            "1.2.3-SNAPSHOT-123",
            "1.0.0",
            "2.0.0",
            "1.1.7",
            "2.0.0+build.1848",
            "2.0.1-alpha.1227",
            "1.0.0-alpha+beta",
            "1.2.3----RC-SNAPSHOT.12.9.1--.12+788",
            "1.2.3----R-S.12.9.1--.12+meta",
            "1.2.3----RC-SNAPSHOT.12.9.1--.12",
            "1.0.0+0.build.1-rc.10000aaa-kk-0.1",
            "999999999999999999.999999999999999999.99999999999999999",
            "1.0.0-0A.is.legal",
        ]

        for validVersion in validVersions {
            let version: MockVersion = try .init(from: validVersion)
            XCTAssertEqual(version.versionString, validVersion)
        }
    }

    func testInitFromStringInvalidVersions() throws {
        let invalidVersions = [
            "1",
            "1.2",
            "1.2.3-0123",
            "1.2.3-0123.0123",
            "1.1.2+.123",
            "+invalid",
            "-invalid",
            "-invalid+invalid",
            "-invalid.01",
            "alpha",
            "alpha.beta",
            "alpha.beta.1",
            "alpha.1",
            "alpha+beta",
            "alpha_beta",
            "alpha.",
            "alpha..",
            "beta",
            "1.0.0-alpha_beta",
            "-alpha.",
            "1.0.0-alpha..",
            "1.0.0-alpha..1",
            "1.0.0-alpha...1",
            "1.0.0-alpha....1",
            "1.0.0-alpha.....1",
            "1.0.0-alpha......1",
            "1.0.0-alpha.......1",
            "01.1.1",
            "1.01.1",
            "1.1.01",
            "1.2",
            "1.2.3.DEV",
            "1.2-SNAPSHOT",
            "1.2.31.2.3----RC-SNAPSHOT.12.09.1--..12+788",
            "1.2-RC-SNAPSHOT",
            "-1.0.3-gamma+b7718",
            "+justmeta",
            "9.8.7+meta+meta",
            "9.8.7-whatever+meta+meta",
            "99999999999999999999999.999999999999999999.99999999999999999----RC-SNAPSHOT.12.09.1--------------------------------..12",
        ]

        for invalidVersion in invalidVersions {
            XCTAssertThrowsError(try MockVersion(from: invalidVersion))
        }
    }

    func testInitStringLiteralVersions() throws {
        XCTAssertEqual(("0.0.4" as MockVersion).versionString, "0.0.4")
        XCTAssertEqual(("1.2.3" as MockVersion).versionString, "1.2.3")
        XCTAssertEqual(("10.20.30" as MockVersion).versionString, "10.20.30")
        XCTAssertEqual(("1.1.2-prerelease+meta" as MockVersion).versionString, "1.1.2-prerelease+meta")
        XCTAssertEqual(("1.1.2+meta" as MockVersion).versionString, "1.1.2+meta")
        XCTAssertEqual(("1.1.2+meta-valid" as MockVersion).versionString, "1.1.2+meta-valid")
        XCTAssertEqual(("1.0.0-alpha" as MockVersion).versionString, "1.0.0-alpha")
        XCTAssertEqual(("1.0.0-beta" as MockVersion).versionString, "1.0.0-beta")
        XCTAssertEqual(("1.0.0-alpha.beta" as MockVersion).versionString, "1.0.0-alpha.beta")
        XCTAssertEqual(("1.0.0-alpha.beta.1" as MockVersion).versionString, "1.0.0-alpha.beta.1")
        XCTAssertEqual(("1.0.0-alpha.1" as MockVersion).versionString, "1.0.0-alpha.1")
        XCTAssertEqual(("1.0.0-alpha0.valid" as MockVersion).versionString, "1.0.0-alpha0.valid")
        XCTAssertEqual(("1.0.0-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay" as MockVersion).versionString, "1.0.0-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay")
        XCTAssertEqual(("1.0.0-rc.1+build.1" as MockVersion).versionString, "1.0.0-rc.1+build.1")
        XCTAssertEqual(("2.0.0-rc.1+build.123" as MockVersion).versionString, "2.0.0-rc.1+build.123")
        XCTAssertEqual(("1.2.3-beta" as MockVersion).versionString, "1.2.3-beta")
        XCTAssertEqual(("10.2.3-DEV-SNAPSHOT" as MockVersion).versionString, "10.2.3-DEV-SNAPSHOT")
        XCTAssertEqual(("1.2.3-SNAPSHOT-123" as MockVersion).versionString, "1.2.3-SNAPSHOT-123")
        XCTAssertEqual(("1.0.0" as MockVersion).versionString, "1.0.0")
        XCTAssertEqual(("2.0.0" as MockVersion).versionString, "2.0.0")
        XCTAssertEqual(("1.1.7" as MockVersion).versionString, "1.1.7")
        XCTAssertEqual(("10.2.3-DEV-SNAPSHOT" as MockVersion).versionString, "10.2.3-DEV-SNAPSHOT")
        XCTAssertEqual(("10.2.3-DEV-SNAPSHOT" as MockVersion).versionString, "10.2.3-DEV-SNAPSHOT")
        XCTAssertEqual(("10.2.3-DEV-SNAPSHOT" as MockVersion).versionString, "10.2.3-DEV-SNAPSHOT")
        XCTAssertEqual(("1.1.7" as MockVersion).versionString, "1.1.7")
        XCTAssertEqual(("2.0.0+build.1848" as MockVersion).versionString, "2.0.0+build.1848")
        XCTAssertEqual(("2.0.1-alpha.1227" as MockVersion).versionString, "2.0.1-alpha.1227")
        XCTAssertEqual(("1.0.0-alpha+beta" as MockVersion).versionString, "1.0.0-alpha+beta")
        XCTAssertEqual(("1.2.3----RC-SNAPSHOT.12.9.1--.12+788" as MockVersion).versionString, "1.2.3----RC-SNAPSHOT.12.9.1--.12+788")
        XCTAssertEqual(("1.2.3----R-S.12.9.1--.12+meta" as MockVersion).versionString, "1.2.3----R-S.12.9.1--.12+meta")
        XCTAssertEqual(("1.2.3----RC-SNAPSHOT.12.9.1--.12" as MockVersion).versionString, "1.2.3----RC-SNAPSHOT.12.9.1--.12")
        XCTAssertEqual(("1.0.0+0.build.1-rc.10000aaa-kk-0.1" as MockVersion).versionString, "1.0.0+0.build.1-rc.10000aaa-kk-0.1")
        XCTAssertEqual(("999999999999999999.999999999999999999.99999999999999999" as MockVersion).versionString, "999999999999999999.999999999999999999.99999999999999999")
        XCTAssertEqual(("1.0.0-0A.is.legal" as MockVersion).versionString, "1.0.0-0A.is.legal")
    }

    func testIncrementMajorVersion() throws {
        XCTAssertEqual(("1.2.3" as MockVersion).increment(.major), "2.0.0")
        XCTAssertEqual(("999.999.999" as MockVersion).increment(.major), "1000.0.0")
        XCTAssertEqual(("1.2.3-alpha.1" as MockVersion).increment(.major), "2.0.0")
        XCTAssertEqual(("1.2.3+build.1" as MockVersion).increment(.major), "2.0.0")
    }

    func testIncrementMinorVersion() throws {
        XCTAssertEqual(("1.2.3" as MockVersion).increment(.minor), "1.3.0")
        XCTAssertEqual(("999.999.999" as MockVersion).increment(.minor), "999.1000.0")
        XCTAssertEqual(("1.2.3-alpha.1" as MockVersion).increment(.minor), "1.3.0")
        XCTAssertEqual(("1.2.3+build.1" as MockVersion).increment(.minor), "1.3.0")
    }

    func testIncrementPatchVersion() throws {
        XCTAssertEqual(("1.2.3" as MockVersion).increment(.patch), "1.2.4")
        XCTAssertEqual(("999.999.999" as MockVersion).increment(.patch), "999.999.1000")
        XCTAssertEqual(("1.2.3-alpha.1" as MockVersion).increment(.patch), "1.2.4")
        XCTAssertEqual(("1.2.3+build.1" as MockVersion).increment(.patch), "1.2.4")
    }

    func testCompareVersions() throws {
        XCTAssertGreaterThan("1.0.0" as MockVersion, "0.999999999.999999999")
        XCTAssertGreaterThan("1.2.0" as MockVersion, "1.1.999999999")
        XCTAssertGreaterThan("1.2.2" as MockVersion, "1.2.1")
        XCTAssertGreaterThan("1.0.0" as MockVersion, "1.0.0-alpha")
        XCTAssertGreaterThan("1.0.0-100" as MockVersion, "1.0.0-99")
        XCTAssertGreaterThan("1.0.0-alpha.1" as MockVersion, "1.0.0-1000000")
        XCTAssertGreaterThan("1.0.0-alpha.1" as MockVersion, "1.0.0-alpha")
        XCTAssertGreaterThan("1.0.0-alpha.beta" as MockVersion, "1.0.0-alpha.1")
        XCTAssertGreaterThan("1.0.0-beta" as MockVersion, "1.0.0-alpha.beta")
        XCTAssertGreaterThan("1.0.0-beta.2" as MockVersion, "1.0.0-beta")
        XCTAssertGreaterThan("1.0.0-beta.11" as MockVersion, "1.0.0-beta.2")
        XCTAssertGreaterThan("1.0.0-rc.1" as MockVersion, "1.0.0-beta.11")
        XCTAssertEqual("1.0.0+build.1" as MockVersion, "1.0.0")
        XCTAssertEqual("1.0.0-alpha+build.1" as MockVersion, "1.0.0-alpha")
    }
}
