import Foundation

open class SInjector: Injector {

    private var builders: [String: Any] = [:]
    private var singletonInjectables: Set<String> = []
    private var singletonInstances: [String: Any] = [:]

    public init() {}

    public init(registrators: [Registrator]) {
        registrators.forEach { $0.registerOn(injector: self) }
    }

    public func register<Params, Element>(
        _ injectable: Injectable<Params, Element>,
        builder: @escaping (Injector, Params) -> Element
    ) {
        let key: String = buildKey(for: injectable)

        builders[key] = builder
    }

    public func registerSingleton<Params, Element>(
        _ injectable: Injectable<Params, Element>,
        builder: @escaping (Injector, Params) -> Element
    ) {
        let key: String = buildKey(for: injectable)

        builders[key] = builder
        singletonInjectables.insert(key)
    }

    public func resolve<Params, Element>(_ resolver: Resolver<Params, Element>) -> Element {
        let key: String = buildKey(for: resolver.injectable)
        guard
            let builder = builders[key] as? (Injector, Params) -> Element
        else {
            fatalError("No builder registered for \(resolver.injectable)")
        }

        let instance: Element = singletonInstances[key] as? Element ?? builder(self, resolver.parameters)

        if singletonInjectables.contains(key) { singletonInstances[key] = instance }

        return instance
    }
}

// MARK: - Key
private extension SInjector {

    func buildKey<Params, Element>(for injectable: Injectable<Params, Element>) -> String {
        "\(type(of: injectable))"
    }
}
