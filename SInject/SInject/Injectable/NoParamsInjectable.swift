import Foundation

open class NoParamsInjectable<Element>: Injectable<Void, Element> {

    public var resolver: Resolver<Void, Element> {
        Resolver(injectable: self, parameters: ())
    }
}
