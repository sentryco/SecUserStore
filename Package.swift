// swift-tools-version:5.9
import PackageDescription

let package = Package(
   name: "SecUserStore",
   platforms: [
      .macOS(.v14), // macOS 14 and later
      .iOS(.v17), // iOS 17 and later
   ],
   products: [
      .library(
         name: "SecUserStore",
         targets: ["SecUserStore"]),
   ],
   dependencies: [
      .package(url: "https://github.com/sentryco/Key", branch: "main"),
      .package(url: "https://github.com/eonist/JSONSugar.git", branch: "master"), // Adds JSONSugar as a dependency
   ],
   targets: [
      .target(
         name: "SecUserStore",
         dependencies: ["Key", "JSONSugar"]),
      .testTarget(
         name: "SecUserStoreTests",
         dependencies: ["Key", "SecUserStore", "JSONSugar"])
   ]
)
