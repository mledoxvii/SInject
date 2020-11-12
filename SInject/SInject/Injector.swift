import Foundation

public protocol Injector {

    func register<Params, Element>(
        _ injectable: Injectable<Params, Element>,
        builder: @escaping (Injector, Params) -> Element
    )

    func registerSingleton<Params, Element>(
        _ injectable: Injectable<Params, Element>,
        builder: @escaping (Injector, Params) -> Element
    )

    func resolve<Params, Element>(_ resolver: Resolver<Params, Element>) -> Element
}
