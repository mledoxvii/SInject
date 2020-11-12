import Foundation

open class Injectable<Params, Element> {

    public init() {}

    public func using(_ parameters: Params) -> Resolver<Params, Element> {
        Resolver(injectable: self, parameters: parameters)
    }
}
