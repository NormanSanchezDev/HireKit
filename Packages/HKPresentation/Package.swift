// swift-tools-version: 6.4

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ApproachableConcurrency"),
    .enableUpcomingFeature("MemberImportVisibility"),
]

let package = Package(
    name: "HKPresentation",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(name: "HKPresentation", targets: ["HKPresentation"]),
    ],
    dependencies: [
        .package(path: "../HKDomain"),
        .package(path: "../HKDesignSystem"),
    ],
    targets: [
        .target(
            name: "HKPresentation",
            dependencies: ["HKDomain", "HKDesignSystem"],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "HKPresentationTests",
            dependencies: ["HKPresentation", "HKDomain"],
            swiftSettings: swiftSettings
        ),
    ]
)
