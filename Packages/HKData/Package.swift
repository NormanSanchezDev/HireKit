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
        .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "HKData",
            dependencies: [
                "HKDomain",
                .product(name: "Supabase", package: "supabase-swift")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "HKDataTests",
            dependencies: [
                "HKData",
                "HKDomain",
                .product(name: "Supabase", package: "supabase-swift")
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
