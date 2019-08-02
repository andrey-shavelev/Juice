//
// Created by Andrey Shavelev on 2019-08-02.
//

import XCTest
@testable import blaze

final class ChildScopeRegistrationsTests: XCTestCase {

    func testRedeclaredInstancePerScopeIsResolvedWithingChildScopeAndItsChildren() throws {
        let container = Container {
            $0.register(injectable: Orange.self)
                .instancePerDependency()
                .as(Fruit.self)

            $0.register(injectable: FreshJuice.self)
                .instancePerDependency()
                .asSelf()
        }

        let childContainer = container.createChildScope{
            $0.register(injectable: Apple.self)
                .instancePerDependency()
                .as(Fruit.self)
        }

        XCTAssertNoThrow(try childContainer.resolve(FreshJuice.self))

        var juice = try childContainer.resolve(FreshJuice.self)

        XCTAssert(juice.fruit is Apple)
    }

    func testSingleInstanceRegisteredInParentScopeReceivesItsDependenciesFromParentScope() throws  {

    }
}

