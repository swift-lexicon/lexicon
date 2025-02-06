// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "lexicon",
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
    targets: [
        .target(name: "Lexicon"),
        .target(name: "LexiconJson", dependencies: ["Lexicon"]),
        .executableTarget(name: "LexiconClient", dependencies: ["Lexicon"]),
        .testTarget(
            name: "LexiconTests",
            dependencies: ["Lexicon"]
        ),
        .testTarget(
            name: "LexiconPerformanceTests",
            dependencies: ["Lexicon", "LexiconJson"]
        ),
    ]
)
