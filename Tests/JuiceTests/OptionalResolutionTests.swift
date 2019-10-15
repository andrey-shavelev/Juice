//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
import Juice

final class OptionalResolutionTests: XCTestCase {

    func testReturnsNilIfResolvingNonRegisteredService() throws {
        let emptyContainer = Container()

        let fruit = try emptyContainer.resolveOptional(Fruit.self)
        let secondFruit = try emptyContainer.resolve(Fruit?.self)

        XCTAssertNil(fruit)
        XCTAssertNil(secondFruit)
    }

    func testReturnsOptionalServiceInstanceWhenRegistered() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                .instancePerDependency()
                .as(Fruit.self)
        }

        let fruit = try container.resolveOptional(Fruit.self)
        let secondFruit = try container.resolve(Fruit?.self)

        XCTAssertTrue(fruit is Apple)
        XCTAssertTrue(secondFruit is Apple)
    }

    func testResolvesOptionalServiceWithParameter() throws {
        let container = try Container { builder in
            builder.register(injectable: FreshJuice.self)
                .instancePerDependency()
                .as(Juice.self)
        }

        let juice = try container.resolveOptional(Juice.self, withArguments: Argument<Fruit>(Apple()))

        XCTAssertTrue(juice?.fruit is Apple)
    }
}
