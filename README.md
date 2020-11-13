# SInject
Simple dependency injection framework for Swift

## Installation

### Swift Package Manager

You can install this framework on your application by adding a new _Swift Package_ dependency and specifying this repository's url.

If you want to use it in your own _Swift Package_, simply add the package depency in your _manifest_

```swift
let package = Package(
    ...
    depedencies: [
        .package(url: "https://github.com/mledoxvii/SInject", from: "1.0.0"),
    ],
    ...
)
```
