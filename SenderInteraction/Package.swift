// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SenderInteraction",
    products: [
        .library(
            name: "SenderInteraction",
            targets: ["SenderInteraction"]),
    ],
    dependencies: [
        .package(path: "../DaemonInteraction")
    ],
    targets: [
        .target(name: "SenderInteraction", 
                dependencies: ["DaemonInteraction"])
    ]
)
