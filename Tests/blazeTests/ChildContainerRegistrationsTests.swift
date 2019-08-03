//
// Created by Andrey Shavelev on 2019-08-02.
//

import XCTest
@testable import blaze

final class ChildContainerRegistrationsTests: XCTestCase {

    func testRedeclaredInstancePerScopeIsResolvedWithingChildScopeAndItsChildren() throws {
        let container = Container {
            $0.register(injectable: Orange.self)
                .instancePerDependency()
                .as(Fruit.self)

            $0.register(injectable: FreshJuice.self)
                .instancePerDependency()
                .asSelf()
        }

        let childContainer = container.createChildContainer{
            $0.register(injectable: Apple.self)
                .instancePerDependency()
                .as(Fruit.self)
        }

        XCTAssertNoThrow(try childContainer.resolve(FreshJuice.self))

        let juice = try childContainer.resolve(FreshJuice.self)

        XCTAssert(juice.fruit is Apple)
    }

    func testSingleInstanceRegisteredInParentScopeReceivesItsDependenciesFromParentScope() throws  {
        let container = Container {
            $0.register(injectable: Orange.self)
                    .instancePerDependency()
                    .as(Fruit.self)

            $0.register(injectable: FreshJuice.self)
                    .singleInstance()
                    .asSelf()
        }

        let childContainer = container.createChildContainer{
            $0.register(injectable: Apple.self)
                    .instancePerDependency()
                    .as(Fruit.self)
        }

        XCTAssertNoThrow(try childContainer.resolve(FreshJuice.self))

        let juice = try childContainer.resolve(FreshJuice.self)

        XCTAssert(juice.fruit is Orange)
    }

    func testResolvesSameSingleInstanceFromParentAndChildScope() throws {
        let container = Container {
            $0.register(injectable: Orange.self)
                    .instancePerDependency()
                    .as(Fruit.self)

            $0.register(injectable: FreshJuice.self)
                    .singleInstance()
                    .asSelf()
        }

        let childContainer = container.createChildContainer()

        XCTAssertNoThrow(try childContainer.resolve(FreshJuice.self))
        XCTAssertNoThrow(try container.resolve(FreshJuice.self))

        let juiceFromChildContainer = try childContainer.resolve(FreshJuice.self)
        let juiceFromParentContainer = try childContainer.resolve(FreshJuice.self)

        XCTAssert(juiceFromParentContainer === juiceFromChildContainer)
    }

    func testPassesParametersToServiceRegisteredInParentScopeWhenResolvedFromChildScope() throws {
        let container = Container {
            $0.register(injectable: Orange.self)
                    .instancePerDependency()
                    .as(Fruit.self)

            $0.register(injectable: FreshJuice.self)
                    .instancePerDependency()
                    .asSelf()
        }

        let childContainer = container.createChildContainer()

        XCTAssertNoThrow(try childContainer.resolve(FreshJuice.self, withParameters: Apple()))

        let juice = try childContainer.resolve(FreshJuice.self, withParameters: Apple())

        XCTAssert(juice.fruit is Apple)
    }

    func testResolvesInstanceRegisteredByNamedScope() throws {
        let container = Container {
            $0.register(injectable: Orange.self)
                    .instancePerDependency()
                    .as(Fruit.self)

            $0.register(injectable: FreshJuice.self)
                    .instancePerContainer(name: "zen")
                    .asSelf()
        }

        let zenScope = container.createChildContainer(name: "zen")
        let gardenScope = zenScope.createChildContainer(name: "garden")
        let innerZenScope = gardenScope.createChildContainer(name: "zen")

        XCTAssertThrowsError(try container.resolve(FreshJuice.self))
        XCTAssertNoThrow(try zenScope.resolve(FreshJuice.self))
        XCTAssertNoThrow(try gardenScope.resolve(FreshJuice.self))
        XCTAssertNoThrow(try innerZenScope.resolve(FreshJuice.self))

        let zenFreshJuice = try zenScope.resolve(FreshJuice.self)
        let gardenFreshJuice = try zenScope.resolve(FreshJuice.self)
        let innerZenFreshJuice = try innerZenScope.resolve(FreshJuice.self)

        XCTAssert(zenFreshJuice === gardenFreshJuice)
        XCTAssert(gardenFreshJuice !== innerZenFreshJuice)
    }
}

