// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Curl",
    products: [
        .library(name: "Curl", targets: ["Curl"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mxcl/PromiseKit", .upToNextMajor(from: "6.13.2")),
        .package(url: "https://github.com/compote-platform/Shell", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(name: "Curl", dependencies: [
            .byName(name: "Shell"),
            .byName(name: "PromiseKit"),
        ]),
    ]
)
