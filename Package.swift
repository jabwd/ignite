// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ignite",
    dependencies: [
		.package(
			name: "Runloop",
			url: "https://github.com/jabwd/Runloop.git",
			from: "0.1.0"
		),
		.package(
			name: "swift-argument-parser",
			url: "https://github.com/apple/swift-argument-parser.git",
			from: "0.1.0"
		),
    ],
    targets: [
        .target(
            name: "ignite",
            dependencies: [
				"Runloop",
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
		]),
        .testTarget(
            name: "igniteTests",
            dependencies: ["ignite"]),
    ]
)
