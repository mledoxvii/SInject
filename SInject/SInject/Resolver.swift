import Foundation

open class Resolver<Params, Element> {
    public let injectable: Injectable<Params, Element>
    public let parameters: Params

    public init(injectable: Injectable<Params, Element>, parameters: Params) {
        self.injectable = injectable
        self.parameters = parameters
    }
}
