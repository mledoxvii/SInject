// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SInject",
    products: [
        .library(name: "SInject", targets: ["SInject"])
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "SInject",
            url: "https://github.com/mledoxvii/SInject/releases/download/1.0.0/SInject.xcframework.zip",
            checksum: "bca32843f30bfa9614659752fe995f3bd275c993f9bc211b193323028241820a"
        )
    ]
)
