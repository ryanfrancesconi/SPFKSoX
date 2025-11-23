// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// This package will assume C / Objective-C interoperability as it's more common.
// C++ could be enabled with:
// swiftSettings: [.interoperabilityMode(.Cxx)]

// Swift target
private let name: String = "SPFKSoX"

// C/C++ target
private let nameC: String = "\(name)C"

private let platforms: [PackageDescription.SupportedPlatform]? = [
    .macOS(.v12)
]

private let products: [PackageDescription.Product] = [
    .library(
        name: name,
        targets: [name, nameC]
    )
]

private let dependencies: [PackageDescription.Package.Dependency] = [
    .package(name: "SPFKAudioBase", path: "../SPFKAudioBase"),
    .package(name: "SPFKTesting", path: "../SPFKTesting"),

//     .package(url: "https://github.com/ryanfrancesconi/SPFKTesting", branch: "main"),
]


private let targets: [PackageDescription.Target] = [
    // Swift
    .target(
        name: name,
        dependencies: [
            .target(name: nameC),
            .byNameItem(name: "SPFKAudioBase", condition: nil)
        ]
    ),
    
    // C
    .target(
        name: nameC,
        dependencies: [
            .target(name: "libsndfile"),
            .target(name: "libsamplerate"),
            .target(name: "libsox"),
            .target(name: "libmad"),
            .target(name: "libmp3lame"),
            .target(name: "libmpg123"),
        ],
        publicHeadersPath: "include",
        cSettings: [
            .headerSearchPath("include_private")
        ],
        cxxSettings: [
            .headerSearchPath("include_private")
        ]
    ),
    
    // path: relative to the package root

    .binaryTarget(
        name: "libsndfile",
        path: "Frameworks/libsndfile.xcframework"
    ),
    
    .binaryTarget(
        name: "libsamplerate",
        path: "Frameworks/libsamplerate.xcframework"
    ),
    
    .binaryTarget(
        name: "libsox",
        path: "Frameworks/libsox.xcframework"
    ),

    .binaryTarget(
        name: "libmad",
        path: "Frameworks/libmad.xcframework"
    ),

    .binaryTarget(
        name: "libmp3lame",
        path: "Frameworks/libmp3lame.xcframework"
    ),

    .binaryTarget(
        name: "libmpg123",
        path: "Frameworks/libmpg123.xcframework"
    ),

    .testTarget(
        name: "\(name)Tests",
        dependencies: [
            .byNameItem(name: name, condition: nil),
            .byNameItem(name: nameC, condition: nil),
            .byNameItem(name: "SPFKTesting", condition: nil)
        ],
        resources: [
        ]
    )
]

let package = Package(
    name: name,
    defaultLocalization: "en",
    platforms: platforms,
    products: products,
    dependencies: dependencies,
    targets: targets,
    cxxLanguageStandard: .cxx20
)
