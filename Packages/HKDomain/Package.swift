// swift-tools-version: 6.4

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ApproachableConcurrency"),
    .enableUpcomingFeature("MemberImportVisibility"),
]

let package = Package(
    name: "HKDomain",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(name: "HKDomain", targets: ["HKDomain"]),
    ],
    targets: [
        .target(
            name: "HKDomain",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "HKDomainTests",
            dependencies: ["HKDomain"],
            swiftSettings: swiftSettings
        ),
    ]
)
