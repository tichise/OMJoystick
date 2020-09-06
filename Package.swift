// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "OMJoystick",
    products: [
        .library(name: "OMJoystick", targets: ["OMJoystick"])
    ],
    dependencies: [],
    targets: [
        .target(name: "OMJoystick", path: "Sources"),
        .testTarget(name: "OMJoystickTests", dependencies: ["OMJoystick"]),
    ],
    swiftLanguageVersions: [.v5]
)
