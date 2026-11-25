// swift-tools-version: 6.4

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ApproachableConcurrency"),
    .enableUpcomingFeature("MemberImportVisibility"),
]

let package = Package(
    name: "HKCore",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(name: "HKCore", targets: ["HKCore"]),
    ],
    targets: [
        .target(
            name: "HKCore",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "HKCoreTests",
            dependencies: ["HKCore"],
            swiftSettings: swiftSettings
        ),
    ]
)
