// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppleMusicKit",
    defaultLocalization: "ja",
    products: [
        .library(name: "AppleMusicKit", targets: ["AppleMusicKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "AppleMusicKit", dependencies: []),
        .testTarget(name: "AppleMusicKitTests", dependencies: ["AppleMusicKit"]),
    ]
)
