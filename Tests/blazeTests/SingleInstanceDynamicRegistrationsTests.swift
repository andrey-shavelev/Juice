import XCTest
@testable import blaze

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
            builder.register(injectable: ServiceWithThreeParameters.self)
                    .singleInstance()
                    .asSelf()

            builder.register(injectable: FirstDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: SecondDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: ThirdDependency.self)
                    .singleInstance()
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(ServiceWithThreeParameters.self))
    }

    func testRegisterAndResolveSingleInstanceWithFourDependencies() throws {
        let container = try Container { builder in
            builder.register(injectable: ServiceWithFourParameters.self)
                    .singleInstance()
                    .asSelf()

            builder.register(injectable: FirstDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: SecondDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: ThirdDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: FourthDependency.self)
                    .singleInstance()
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(ServiceWithFourParameters.self))
    }

    func testRegisterAndResolveSingleInstanceWithFiveDependencies() throws {
        let container = try Container { builder in
            builder.register(injectable: ServiceWithFiveParameters.self)
                    .singleInstance()
                    .asSelf()

            builder.register(injectable: FirstDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: SecondDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: ThirdDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: FourthDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: FifthDependency.self)
                    .singleInstance()
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(ServiceWithFiveParameters.self))
    }

    func testRegisterAndResolveSingleInstanceWithCustomDependencies() throws {
        let container = try Container { builder in
            builder.register(injectable: ServiceWithCustomParameters.self)
                    .singleInstance()
                    .asSelf()

            builder.register(injectable: FirstDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: SecondDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: ThirdDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: FourthDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: FifthDependency.self)
                    .singleInstance()
                    .asSelf()
            builder.register(injectable: SixthDependency.self)
                    .singleInstance()
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(ServiceWithCustomParameters.self))
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
