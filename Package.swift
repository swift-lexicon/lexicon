// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Lexicon",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "Lexicon",
            targets: ["Lexicon"]
        ),
        .library(
            name: "LexiconJson",
            targets: ["LexiconJson"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [
        .macro(
            name: "LexiconMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "Lexicon", dependencies: ["LexiconMacros"]),
        .target(name: "LexiconJson", dependencies: ["Lexicon"]),
        .executableTarget(name: "LexiconClient", dependencies: ["Lexicon"]),
        .testTarget(
            name: "LexiconMacroTests",
            dependencies: [
                "LexiconMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "LexiconTests",
            dependencies: ["Lexicon"]
        ),
        .testTarget(
            name: "LexiconJsonTests",
            dependencies: ["LexiconJson"]
        ),
    ]
)
