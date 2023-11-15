// The Swift Programming Language
// https://docs.swift.org/swift-book

@freestanding(expression)
public macro semanticVersioning(_ stringLiteral: String) -> String = #externalMacro(module: "SemanticVersioningMacroMacros", type: "SemanticVersioningMacro")
