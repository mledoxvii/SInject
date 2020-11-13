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

## Basic Usage

For a simple use-case where we have a class with a dependency like the following.

```swift
protocol ApiClient {
    func requestData() -> String
}

class SomeController {
    private let apiClient: ApiClient

    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    func onSomeEventTriggered() {
        print(apiClient.requestData())
    }
}
```

We may want to use a stubbed version of the client for our _Debug_ mode.

```swift
class ReleaseClient: ApiClient {

    func requestData() -> String {
        // Perform api call
    }
}

class StubbedClient: ApiClient {

    func requestData() -> String {
        return "Stubbed data"
    }
}
```

In order to inject the proper implementation we need to declare an _injectable_ for the `ApiClient` protocol.

```swift
class ApiClientInjectable: NoParamsInjectable<ApiClient> {}
```

> **IMPORTANT:** Do not use `typealias` to declare _injectables_ as their type's string representation is used as a key when they are registered.

Next, register the _injectable_ to the `Injector` instance providing the initialization logic.

```swift
let injector: Injector = SInjector()

injector.register(ApiClientInjectable()) { _, _ in
    guard !isDebugMode else {
        return StubbedClient()
    }
    return ReleaseClient()
}
```

Finally, you can inject the proper implementation using the injector.

```swift
let controller: SomeController = SomeController(
    apiClient: injector.resolve(ApiClientInjectable().resolver)
)

controller.onSomeEventTriggered()
```
