// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Parsecco",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "Parsecco",
            targets: ["Parsecco"]
        ),
        .executable(
            name: "ParseccoClient",
            targets: ["ParseccoClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [
        .macro(
            name: "ParseccoMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "Parsecco", dependencies: ["ParseccoMacros"]),
        .executableTarget(name: "ParseccoClient", dependencies: ["Parsecco"]),
        .testTarget(
            name: "ParseccoMacroTests",
            dependencies: [
                "ParseccoMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "ParseccoTests",
            dependencies: ["Parsecco"]
        ),
    ]
)
