// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "OMJoystickView",
    products: [
        .library(name: "OMJoystickView", targets: ["OMJoystickView"])
    ],
    dependencies: [],
    targets: [
        .target(name: "OMJoystickView", path: "Sources"),
        .testTarget(name: "OMJoystickViewTests", dependencies: ["OMJoystickView"]),
    ],
    swiftLanguageVersions: [.v5]
)
