import SemanticVersioningParser
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SemanticVersioningMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            let argument = node.argumentList.first?.expression,
            let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
            segments.count == 1,
            case .stringSegment(let literalSegment)? = segments.first
        else {
            throw SemanticVersioningMacroError.requiresStaticStringLiteral
        }
        
        _ = try SemanticVersioningParser.parse(from: literalSegment.content.text)
        return argument
    }
}

public enum SemanticVersioningMacroError: Error {
    case requiresStaticStringLiteral
}

@main
struct SemanticVersioningMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SemanticVersioningMacro.self,
    ]
}
