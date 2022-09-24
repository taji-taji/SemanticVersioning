# SemanticVersioning [x.x.x]

This package provides the Swift protocol compatible with [Semantic Versioning (2.0.0)](https://semver.org/).

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

## Requirements

- Swift 5.5 or later
- macOS 10.13

## Supported Platforms

- Apple Platforms
- Linux

## Usage

### Package.swift

1. Add SemanticVersioning to your `Package.swift`  dependencies:

    ```swift
    .package(url: "https://github.com/taji-taji/SemanticVersioning.git", from: "0.0.1")
    ```

2. Add SemanticVersioning to your dependencies of `SemanticVersioning` target:

    ```swift
    .product(name: "SemanticVersioning", package: "SemanticVersioning")
    ```
