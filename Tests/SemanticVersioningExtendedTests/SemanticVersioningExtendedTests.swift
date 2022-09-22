import Mocks
import XCTest
@testable import SemanticVersioningExtended

final class SemanticVersioningExtendedTests: XCTestCase {
    func testShortVersionString() throws {
        XCTAssertEqual(MockVersion("1.2.3").shortVersionString, "1.2.3")
        XCTAssertEqual(MockVersion("1.2.0").shortVersionString, "1.2")
        XCTAssertEqual(MockVersion("1.0.0").shortVersionString, "1")
    }
}
