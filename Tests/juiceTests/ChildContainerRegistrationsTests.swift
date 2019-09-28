//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
import juice

final class ChildContainerRegistrationsTests: XCTestCase {

    func testRedeclaredInstancePerScopeIsResolvedWithingChildScopeAndItsChildren() throws {
        let container = try Container {
            $0.register(injectable: Orange.self)
                    .instancePerDependency()
                    .as(Fruit.self)

            $0.register(injectable: FreshJuice.self)
                    .instancePerDependency()
                    .asSelf()
        }

        let childContainer = try container.createChildContainer {
            $0.register(injectable: Apple.self)
                    .instancePerDependency()
                    .as(Fruit.self)
        }

        XCTAssertNoThrow(try childContainer.resolve(FreshJuice.self))

        let juice = try childContainer.resolve(FreshJuice.self)

        XCTAssert(juice.fruit is Apple)
    }

    func testSingleInstanceRegisteredInParentScopeReceivesItsDependenciesFromParentScope() throws {
        let container = try Container {
            $0.register(injectable: Orange.self)
                    .instancePerDependency()
                    .as(Fruit.self)

            $0.register(injectable: FreshJuice.self)
                    .singleInstance()
                    .asSelf()
        }

        let childContainer = try container.createChildContainer {
            $0.register(injectable: Apple.self)
                    .instancePerDependency()
                    .as(Fruit.self)
        }

        XCTAssertNoThrow(try childContainer.resolve(FreshJuice.self))

        let juice = try childContainer.resolve(FreshJuice.self)

        XCTAssert(juice.fruit is Orange)
    }

    func testResolvesSameSingleInstanceFromParentAndChildScope() throws {
        let container = try Container {
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
        let container = try Container {
            $0.register(injectable: Orange.self)
                    .instancePerDependency()
                    .as(Fruit.self)

            $0.register(injectable: FreshJuice.self)
                    .instancePerDependency()
                    .asSelf()
        }

        let childContainer = container.createChildContainer()
        XCTAssertNoThrow(try childContainer.resolve(FreshJuice.self, withParameters: Parameter<Fruit>(Apple())))
        let juice = try childContainer.resolve(FreshJuice.self, withParameters: Parameter<Fruit>(Apple()))
        XCTAssert(juice.fruit is Apple)
    }

    func testResolvesInstanceRegisteredByNamedScope() throws {
        let container = try Container {
            $0.register(injectable: Orange.self)
                    .instancePerDependency()
                    .as(Fruit.self)

            $0.register(injectable: FreshJuice.self)
                .instancePerContainer(withName: "garden")
                    .asSelf()
        }

        let gardenScope = container.createChildContainer(name: "garden")
        let zenScope = gardenScope.createChildContainer(name: "zen")
        let innerGardenScope = zenScope.createChildContainer(name: "garden")

        XCTAssertThrowsError(try container.resolve(FreshJuice.self))
        XCTAssertNoThrow(try gardenScope.resolve(FreshJuice.self))
        XCTAssertNoThrow(try zenScope.resolve(FreshJuice.self))
        XCTAssertNoThrow(try innerGardenScope.resolve(FreshJuice.self))

        let zenFreshJuice = try gardenScope.resolve(FreshJuice.self)
        let gardenFreshJuice = try gardenScope.resolve(FreshJuice.self)
        let innerZenFreshJuice = try innerGardenScope.resolve(FreshJuice.self)

        XCTAssert(zenFreshJuice === gardenFreshJuice)
        XCTAssert(gardenFreshJuice !== innerZenFreshJuice)
    }

    func testSingleInstanceCustomInjectableResolvedFromChildContainerReceivesCorrectResolutionScope() throws {
        let container = try Container {
            $0.register(injectable: HomeMadeJuice.self)
                    .singleInstance()
                    .asSelf()
            $0.register(injectable: Apple.self)
                    .instancePerDependency()
                    .as(Fruit.self)
        }

        let childContainer = try container.createChildContainer {
            $0.register(injectable: Orange.self)
                    .instancePerDependency()
                    .as(Fruit.self)
        }

        let juice = try childContainer.resolve(HomeMadeJuice.self)

        XCTAssert(juice.fruit is Apple)
    }
}

