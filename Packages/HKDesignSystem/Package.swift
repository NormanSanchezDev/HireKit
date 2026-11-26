// swift-tools-version: 6.4

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ApproachableConcurrency"),
    .enableUpcomingFeature("MemberImportVisibility"),
]

let package = Package(
    name: "HKDesignSystem",
    defaultLocalization: "es",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(name: "HKDesignSystem", targets: ["HKDesignSystem"]),
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.6.1"),
    ],
    targets: [
        .target(
            name: "HKDesignSystem",
            dependencies: [.product(name: "Lottie", package: "lottie-spm")],
            resources: [.process("Resources")],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "HKDesignSystemTests",
            dependencies: ["HKDesignSystem"],
            swiftSettings: swiftSettings
        ),
    ]
)
