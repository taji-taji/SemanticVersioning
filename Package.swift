// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SemanticVersioning",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v12),
        .watchOS(.v4),
        .tvOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SemanticVersioning",
            targets: ["SemanticVersioning"]),
        .library(
            name: "SemanticVersioningExtended",
            targets: ["SemanticVersioningExtended"]),
        .library(
            name: "SemanticVersioningMacro",
            targets: ["SemanticVersioningMacro"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .target(
            name: "SemanticVersioningParser",
            dependencies: []),
        .testTarget(
            name: "SemanticVersioningParserTests",
            dependencies: ["SemanticVersioningParser"]),
        .target(
            name: "SemanticVersioning",
            dependencies: ["SemanticVersioningParser"]),
        .testTarget(
            name: "SemanticVersioningTests",
            dependencies: ["SemanticVersioning", "Mocks"]),
        .target(
            name: "SemanticVersioningExtended",
            dependencies: ["SemanticVersioning"]),
        .testTarget(
            name: "SemanticVersioningExtendedTests",
            dependencies: ["SemanticVersioningExtended", "Mocks"]),
        .target(
            name: "Mocks",
            dependencies: ["SemanticVersioning"]),
        .macro(
            name: "SemanticVersioningMacroMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                "SemanticVersioningParser",
            ]
        ),
        .target(name: "SemanticVersioningMacro", dependencies: ["SemanticVersioningMacroMacros"]),
        .testTarget(
            name: "SemanticVersioningMacroTests",
            dependencies: [
                "SemanticVersioningMacroMacros",
                "SemanticVersioningParser",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
