//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
import juice

final class SingleInstanceDynamicRegistrationsTests: XCTestCase {
    func testRegistersAndResolvesSingleInstanceService() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                    .singleInstance()
                    .as(Fruit.self)
        }

        XCTAssertNoThrow(try container.resolve(Fruit.self))

        let apple = try container.resolve(Fruit.self)

        XCTAssert(apple is Apple)
    }

    func testReturnsOneInstanceForSingleInstanceService() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                    .singleInstance()
                    .as(Fruit.self)
        }

        let firstFruit = try container.resolve(Fruit.self) as AnyObject?
        let secondFruit = try container.resolve(Fruit.self) as AnyObject?

        XCTAssert(firstFruit === secondFruit)
    }

    func testReturnsOneInstanceForSingleInstanceResolvedAsDifferentService() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                    .singleInstance()
                    .as(Fruit.self)
                    .asSelf()
        }

        let fruit = try container.resolve(Fruit.self) as AnyObject
        let apple = try container.resolve(Apple.self) as AnyObject

        XCTAssert(fruit === apple)
    }

    func testRegisterAndResolveSingleInstanceWithOneDependency() throws {
        let container = try Container { builder in
            builder.register(injectable: FreshJuice.self)
                    .singleInstance()
                    .as(Juice.self)

            builder.register(injectable: Orange.self)
                    .singleInstance()
                    .as(Fruit.self)
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(Juice.self))

        let orangeJuice = try container.resolve(Juice.self)
        let orange = try container.resolve(Orange.self)

        XCTAssert(orangeJuice.fruit is Orange)
        XCTAssert(orangeJuice.fruit as! Orange === orange)
    }

    func testRegisterAndResolveSingleInstanceWithTwoDependencies() throws {
        let container = try Container { builder in
            builder.register(injectable: Compote.self)
                    .singleInstance()
                    .asSelf()

            builder.register(injectable: Pear.self)
                    .singleInstance()
                    .asSelf()
                    .as(Fruit.self)

            builder.register(injectable: Cloves.self)
                    .singleInstance()
                    .asSelf()
                    .as(Spice.self)
        }

        XCTAssertNoThrow(try container.resolve(Compote.self))

        let compote = try container.resolve(Compote.self)
        let pear = try container.resolve(Pear.self)

        XCTAssert(compote.fruit is Pear)
        XCTAssert(compote.spice is Cloves)
        XCTAssert(compote.fruit as! Pear === pear)
        XCTAssert(compote.spice is Cloves)
    }

    func testRegisterAndResolveSingleInstanceWithThreeDependencies() throws {
        let container = try Container { builder in
            builder.register(injectable: FreshMorningSmoothie.self)
                    .singleInstance()
                    .as(Smoothie.self)

            builder.register(injectable: Orange.self)
                    .singleInstance()
                    .as(Fruit.self)
            builder.register(injectable: Strawberry.self)
                    .singleInstance()
                    .as(Berry.self)
            builder.register(injectable: FreshJuice.self)
                    .singleInstance()
                    .as(Juice.self)
        }

        XCTAssertNoThrow(try container.resolve(Smoothie.self))
    }

    func testRegisterAndResolveSingleInstanceWithFourDependencies() throws {
        let container = try Container { builder in
            builder.register(factory: {
                return Cocktail(try $0.resolve(Juice.self), Lime(), Sugar(), SodaWater())
            })
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: Apple.self)
                    .singleInstance()
                    .as(Fruit.self)
            builder.register(injectable: FreshJuice.self)
                    .singleInstance()
                    .as(Juice.self)
            builder.register(injectable: Lime.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: Sugar.self)
                    .singleInstance()
                    .as(Sweetener.self)
            builder.register(injectable: SodaWater.self)
                    .singleInstance()
                    .as(Water.self)
        }

        XCTAssertNoThrow(try container.resolve(Cocktail.self))
    }

    func testRegisterAndResolveSingleInstanceWithFiveDependencies() throws {
        let container = try Container { builder in
            builder.register(injectable: IcyLemonade.self)
                    .singleInstance()
                    .asSelf()

            builder.register(injectable: Apple.self)
                    .singleInstance()
                    .as(Fruit.self)
            builder.register(injectable: FreshJuice.self)
                    .singleInstance()
                    .as(Juice.self)
            builder.register(injectable: Lemon.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: Sugar.self)
                    .singleInstance()
                    .as(Sweetener.self)
            builder.register(injectable: SodaWater.self)
                    .singleInstance()
                    .as(Water.self)
            builder.register(injectable: Ice.self)
                    .singleInstance()
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(IcyLemonade.self))
    }

    func testRegisterAndResolveSingleInstanceWithCustomDependencies() throws {
        let container = try Container { builder in
            builder.register(injectable: TeaBlend.self)
                    .singleInstance()
                    .asSelf()

            builder.register(injectable: Pu_er.self)
                    .singleInstance()
                    .as(Tea.self)
            builder.register(injectable: Orange.self)
                    .singleInstance()
                    .as(Fruit.self)
            builder.register(injectable: Raspberry.self)
                    .singleInstance()
                    .as(Berry.self)
            builder.register(injectable: Lotus.self)
                    .singleInstance()
                    .as(Flower.self)
            builder.register(injectable: Mint.self)
                    .singleInstance()
                    .as(Herb.self)
            builder.register(injectable: Ginger.self)
                    .singleInstance()
                    .as(Spice.self)
        }

        XCTAssertNoThrow(try container.resolve(TeaBlend.self))
    }

    func testResolvesTwoDifferentInstancesIfOneTypeRegisteredTwice() throws {
        let container = try Container { builder in
            builder.register(injectable: Orange.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: Orange.self)
                .singleInstance()
                .as(Fruit.self)
        }

        let fruit = try container.resolve(Fruit.self) as! Orange
        let orange = try container.resolve(Orange.self)

        XCTAssert(fruit !== orange)
    }
}
