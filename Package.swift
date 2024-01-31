// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Lumos",
    products: [
        .library(
            name: "Lumos",
            targets: ["Lumos"]),
    ],
    dependencies: [
        .package(name: "Aspects", url: "https://github.com/djpearce/Aspects", branch: "master"),
    ],
    targets: [
        .target(
            name: "Lumos",
            dependencies: ["Aspects"],
            path: "Lumos/Lumos",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "LumosTests",
            dependencies: ["Lumos"],
            path: "Lumos/LumosTests",
            exclude: ["Info.plist"]
        )
    ]
)
