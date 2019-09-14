//
//  AutoFactoryTests.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 17/06/2019.
//

import XCTest
import blaze

final class ParameterizedResolutionTests: XCTestCase {

    func testPassesParameterToInstancePerDependency() throws {
        let container = try Container { builder in
            builder.register(injectable: Chocolate.self)
                    .instancePerDependency()
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(Chocolate.self, withParameters: Chocolate.Kind.milk))

        let darkChocolate = try container.resolve(Chocolate.self, withParameters: Chocolate.Kind.dark)
        let milkChocolate = try container.resolve(Chocolate.self, withParameters: Chocolate.Kind.milk)

        XCTAssertEqual(Chocolate.Kind.dark, darkChocolate.kind)
        XCTAssertEqual(Chocolate.Kind.milk, milkChocolate.kind)
    }

    func testMissingParameterAreResolvedFromScope() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                    .instancePerDependency()
                    .as(Fruit.self)
            builder.register(injectable: Compote.self)
                    .instancePerDependency()
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(Compote.self, withParameters: Parameter(Cinnamon(), as: Spice.self)))
    }

    func testParametersAreUsedOnlyForServiceItselfAndNotUsedForItsDependencies() throws {
        let container = try Container { builder in
            builder.register(injectable: Orange.self)
                    .instancePerDependency()
                    .as(Fruit.self)
            builder.register(injectable: FreshJuice.self)
                    .instancePerDependency()
                    .as(Juice.self)
            builder.register(injectable: Strawberry.self)
                    .instancePerDependency()
                    .as(Berry.self)
            builder.register(injectable: FreshMorningSmoothie.self)
                    .instancePerDependency()
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(FreshMorningSmoothie.self,
                withParameters: Parameter(Banana(), as: Fruit.self)))

        let smoothie = try container.resolve(FreshMorningSmoothie.self,
                withParameters: Parameter(Banana(), as: Fruit.self))

        let freshJuice = smoothie.juice as! FreshJuice

        XCTAssert(smoothie.fruit is Banana)
        XCTAssert(freshJuice.fruit is Orange)
    }

    func testCustomInjectableCanResolveParametersFromResolutionScope() throws {
        let container = try Container { builder in
            builder.register(injectable: HomeMadeJuice.self)
                    .singleInstance()
                    .asSelf()
        }

        let fruit: Fruit = Apple()
        XCTAssertNoThrow(try container.resolve(HomeMadeJuice.self, withParameters: Parameter(fruit)))

        let juice = try container.resolve(HomeMadeJuice.self, withParameters: Parameter(fruit))
        XCTAssertTrue(fruit as! Apple === juice.fruit as! Apple)
    }

    func testCorrectlyResolvesDependencyWithParametersFromAParametrizedResolutionScope() throws {

    }
}
