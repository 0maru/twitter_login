// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "twitter_login",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "twitter-login", targets: ["twitter_login"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "twitter_login",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
