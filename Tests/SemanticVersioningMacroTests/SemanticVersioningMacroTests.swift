import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(SemanticVersioningMacroMacros)
import SemanticVersioningMacroMacros

let testMacros: [String: Macro.Type] = [
    "semanticVersioning": SemanticVersioningMacro.self,
]
#endif

final class SemanticVersioningMacroTests: XCTestCase {
    func testMacro() throws {
        #if canImport(SemanticVersioningMacroMacros)
        assertMacroExpansion(
            """
            #semanticVersioning("1.2.3-alpha")
            """,
            expandedSource: """
            "1.2.3-alpha"
            """,
            macros: testMacros
        )
        assertMacroExpansion(
            """
            #semanticVersioning("1.2.-alpha")
            """,
            expandedSource: """
            #semanticVersioning("1.2.-alpha")
            """,
            diagnostics: [
                .init(
                    message: """
                            Patch version MUST non-negative integers.
                            Ref: https://semver.org/#spec-item-2
                            """, 
                    line: 1,
                    column: 1
                ),
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
