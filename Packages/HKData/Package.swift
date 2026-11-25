// swift-tools-version: 6.4

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ApproachableConcurrency"),
    .enableUpcomingFeature("MemberImportVisibility"),
]

let package = Package(
    name: "HKData",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(name: "HKData", targets: ["HKData"]),
    ],
    dependencies: [
        .package(path: "../HKDomain"),
    ],
    targets: [
        .target(
            name: "HKData",
            dependencies: ["HKDomain"],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "HKDataTests",
            dependencies: ["HKData", "HKDomain"],
            swiftSettings: swiftSettings
        ),
    ]
)
