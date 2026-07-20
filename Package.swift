// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "GeoShift",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
    ],
    targets: [
        .executableTarget(
            name: "GeoShift",
            path: "Sources/GeoShift",
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "GeoShiftTests",
            dependencies: ["GeoShift"],
            path: "Tests/GeoShiftTests"
        ),
    ]
)
