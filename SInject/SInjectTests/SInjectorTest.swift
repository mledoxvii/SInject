import Foundation
import XCTest
import SInject

class SInjectorTest: XCTestCase {

    var sut: Injector!

    override func setUp() {
        super.setUp()
        sut = SInjector()
    }

    func test_should_return_different_instances_when_using_default_registration() {
        sut.register(ExampleClass1DefaultInjectable()) { _, _ in ExampleClass1(arg: "") }

        let instance1: ExampleClass1 = sut.resolve(ExampleClass1DefaultInjectable().resolver)
        let instance2: ExampleClass1 = sut.resolve(ExampleClass1DefaultInjectable().resolver)

        XCTAssertNotEqual(instance1, instance2)
    }

    func test_should_return_same_instance_when_using_singleton_registration() {
        sut.registerSingleton(ExampleClass1DefaultInjectable()) { _, _ in ExampleClass1(arg: "") }

        let instance1: ExampleClass1 = sut.resolve(ExampleClass1DefaultInjectable().resolver)
        let instance2: ExampleClass1 = sut.resolve(ExampleClass1DefaultInjectable().resolver)

        XCTAssertEqual(instance1, instance2)
    }

    func test_should_resolve_dependencies_recursively() {
        let expectedClass1Arg: String = "This is \(ExampleClass1.self)"
        let expectedClass2Arg: String = "This is \(ExampleClass2.self)"

        sut.register(ExampleClass1DefaultInjectable()) { _, _ in ExampleClass1(arg: expectedClass1Arg) }
        sut.register(ExampleClass2Injectable()) { injector, _ in
            ExampleClass2(
                arg: expectedClass2Arg,
                class1: injector.resolve(ExampleClass1DefaultInjectable().resolver)
            )
        }

        let class2: ExampleClass2 = sut.resolve(ExampleClass2Injectable().resolver)

        XCTAssertEqual(expectedClass1Arg, class2.class1.arg)
        XCTAssertEqual(expectedClass2Arg, class2.arg)
    }

    func test_should_resolve_when_using_arguments() {
        let expectedArg: String = "This is \(ExampleClass2.self)"
        let expectedClass1Arg: ExampleClass1 = .init(arg: "This is \(ExampleClass1.self)")

        sut.register(ExampleClass2ArgsInjectable()) { _, params in
            ExampleClass2(arg: params.arg, class1: params.class1)
        }

        let class2: ExampleClass2 = sut.resolve(ExampleClass2ArgsInjectable().using((
            expectedArg,
            expectedClass1Arg
        )))

        XCTAssertEqual(expectedArg, class2.arg)
        XCTAssertEqual(expectedClass1Arg, class2.class1)
    }

    func test_should_keep_last_builder_when_registering_twice() {
        let expectedArg: String = "This is \(ExampleClass1.self)"

        sut.register(ExampleClass1DefaultInjectable()) { _, _ in ExampleClass1(arg: "") }
        sut.register(ExampleClass1DefaultInjectable()) { _, _ in ExampleClass1(arg: expectedArg) }

        let class1: ExampleClass1 = sut.resolve(ExampleClass1DefaultInjectable().resolver)

        XCTAssertEqual(expectedArg, class1.arg)
    }

    func test_should_resolve_correctly_when_registering_different_injectables_for_same_type() {
        let expectedDefaultArg: String = "Default"
        let expectedHelloArg: String = "Hello"

        sut.register(ExampleClass1DefaultInjectable()) { _, _ in ExampleClass1(arg: expectedDefaultArg) }
        sut.register(ExampleClass1HelloInjectable()) { _, _ in ExampleClass1(arg: expectedHelloArg) }

        let defaultInstance: ExampleClass1 = sut.resolve(ExampleClass1DefaultInjectable().resolver)
        let helloInstance: ExampleClass1 = sut.resolve(ExampleClass1HelloInjectable().resolver)

        XCTAssertEqual(expectedDefaultArg, defaultInstance.arg)
        XCTAssertEqual(expectedHelloArg, helloInstance.arg)
    }

    func test_should_resolve_injectables_when_registered_from_provided_registrators() {
        let expectedClass1Arg: String = ExampleClass1Registrator.ARG
        let expectedClass2Arg: String = ExampleClass2Registrator.ARG
        sut = SInjector(registrators: [
            ExampleClass1Registrator(),
            ExampleClass2Registrator()
        ])

        let class1Instance: ExampleClass1 = sut.resolve(ExampleClass1DefaultInjectable().resolver)
        let class2Instance: ExampleClass2 = sut.resolve(ExampleClass2Injectable().resolver)

        XCTAssertEqual(expectedClass1Arg, class1Instance.arg)
        XCTAssertEqual(expectedClass2Arg, class2Instance.arg)
    }
}

// MARK: - Example Class 1

class ExampleClass1: NSObject {
    let arg: String

    init(arg: String) {
        self.arg = arg
    }
}

class ExampleClass1DefaultInjectable: NoParamsInjectable<ExampleClass1> {}
class ExampleClass1HelloInjectable: NoParamsInjectable<ExampleClass1> {}

class ExampleClass1Registrator: Registrator {

    static let ARG: String = "\(ExampleClass1Registrator.self) arg"

    func registerOn(injector: Injector) {
        injector.register(ExampleClass1DefaultInjectable()) { _, _ in ExampleClass1(arg: Self.ARG) }
    }
}

// MARK: - Example Class 2

class ExampleClass2 {
    let arg: String
    let class1: ExampleClass1

    init(arg: String, class1: ExampleClass1) {
        self.arg = arg
        self.class1 = class1
    }
}

class ExampleClass2Injectable: NoParamsInjectable<ExampleClass2> {}
class ExampleClass2ArgsInjectable: Injectable<(arg: String, class1: ExampleClass1), ExampleClass2> {}

class ExampleClass2Registrator: Registrator {

    static let ARG: String = "\(ExampleClass2Registrator.self) arg"

    func registerOn(injector: Injector) {
        injector.register(ExampleClass2Injectable()) { inj, _ in
            ExampleClass2(
                arg: Self.ARG,
                class1: inj.resolve(ExampleClass1DefaultInjectable().resolver)
            )
        }
    }
}
