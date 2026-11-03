// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "tenjin_plugin",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "tenjin-plugin", targets: ["tenjin_plugin"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // Keep in sync with the TenjinSDK version in tenjin_plugin.podspec
        .package(url: "https://github.com/tenjin/tenjin-ios-sdk.git", exact: "1.19.1")
    ],
    targets: [
        .target(
            name: "tenjin_plugin",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "TenjinSDK", package: "tenjin-ios-sdk")
            ]
        )
    ]
)
