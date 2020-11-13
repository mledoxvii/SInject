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
            checksum: "36f412d6de783e07839d021cea083d4a114dc36a45cb62dfb998f26564745989"
        )
    ]
)
