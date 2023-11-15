# SemanticVersioning [x.x.x]

This package provides the Swift protocol compatible with [Semantic Versioning (2.0.0)](https://semver.org/).


![Test](https://github.com/taji-taji/SemanticVersioning/actions/workflows/test.yml/badge.svg)
[![MIT License](https://img.shields.io/github/license/taji-taji/SemanticVersioning)](https://github.com/taji-taji/SemanticVersioning/blob/main/LICENSE)
[![Latest Version](https://img.shields.io/github/v/release/taji-taji/SemanticVersioning?label=latest%20version)](https://github.com/taji-taji/SemanticVersioning/releases/latest)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftaji-taji%2FSemanticVersioning%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/taji-taji/SemanticVersioning)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftaji-taji%2FSemanticVersioning%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/taji-taji/SemanticVersioning)

## Features

- By conforming to the `SemanticVersioning` protocol, it can be represented as a type that behaves as a version of software compliant with Semantic Versioning (2.0.0).
  ```swift
  import SemanticVersioning

  // conforms to SemanticVersioning
  struct MyAppVersion: SemanticVersioning {
    let major: Int
    let minor: Int
    let patch: Int
    let preRelease: PreRelease?
    let buildMetaData: String?
  }
  ```

- Can be initialized from String literals.
  ```swift
  let appVersion: MyAppVersion = "1.1.1"
  // String literals can also contain pre-release and build metadata.
  // let appVersion: MyAppVersion = "1.1.1-alpha"
  // let appVersion: MyAppVersion = "1.1.1-alpha+build.1"
  ```

- Comparable and Equatable.
  ```swift
  if appVersion > "1.0.0" {
    // Some operation when appVersion is greater than 1.0.0
  } else if appVersion == "0.1.0" {
    // Some operation when appVersion is 0.1.0 
  }
  ```

- Increment version number.
  ```swift
  print(appVersion)
  // -> 1.1.1
  print(appVersion.increment(.major))
  // -> 2.0.0
  print(appVersion.increment(.minor))
  // -> 1.2.0
  print(appVersion.increment(.patch))
  // -> 1.1.2
  ```
  
- Validate version format with macro.
  ```swift
  import SemanticVersioningMacro

  let validVersionString = #semanticVersioning("1.0.0") // Valid format!
  let invalidVersionString = #semanticVersioning("1.0.a") // Invalid format! Compile error!
  ```

## Requirements

- Swift 5.9 or later
- macOS 10.15+ or iOS 12.0+ or watchOS 4.0+ or tvOS 1.0+

## Supported Platforms

- Apple Platforms
- Linux

## Usage

### Package.swift

1. Add SemanticVersioning to your `Package.swift`  dependencies:

    ```swift
    .package(url: "https://github.com/taji-taji/SemanticVersioning.git", from: "1.0.0")
    ```

2. Add SemanticVersioning to your dependencies of `SemanticVersioning` target:

    ```swift
    .product(name: "SemanticVersioning", package: "SemanticVersioning"),
    // If you want to use macro, add `SemanticVersioningMacro`. 
    .product(name: "SemanticVersioningMacro", package: "SemanticVersioning"),
    ```
