//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
import Juice

final class PropertyInjectionTests: XCTestCase {

    func testInjectsDependenciesIntoProperties() throws {
        let container = try Container { builder in
            builder.register(injectable: Pear.self)
                    .singleInstance()
                    .asSelf()
                    .as(Fruit.self)
            builder.register(injectable: Ginger.self)
                    .singleInstance()
                    .as(Spice.self)
            builder.register(injectable: Jam.self)
                    .singleInstance()
                    .asSelf()
                    .injectDependency(into: \.fruit)
                    .injectDependency(into: \.spice)
        }

        XCTAssertNoThrow(try container.resolve(Jam.self))

        let jam = try container.resolve(Jam.self)
        let pear = try container.resolve(Pear.self)

        XCTAssert(pear === jam.fruit as! Pear)
        XCTAssert(jam.spice is Ginger)
    }
    
    func testOptionalPropertyInjection() throws {
        let container = try Container { builder in
            builder.register(injectable: Pear.self)
                    .singleInstance()
                    .asSelf()
                    .as(Fruit.self)
            builder.register(injectable: Jam.self)
                    .singleInstance()
                    .asSelf()
                    .injectDependency(into: \.fruit)
                    .injectOptionalDependency(into: \.spice)
        }
        
        XCTAssertNoThrow(try container.resolve(Jam.self))
        let jam = try container.resolve(Jam.self)
        XCTAssertNil(jam.spice)
    }
    
    func testInjectsDependenciesUsingPropertyWrappers() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: Ice.self)
                .instancePerDependency()
                .asSelf()
            builder.register(injectable: FruitIce.self)
                .instancePerDependency()
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(FruitIce.self))
        
        let fruitIce = try container.resolve(FruitIce.self)

        XCTAssertNotNil(fruitIce.publicApple)
    }

    func testCorrectlyInjectsDependenciesFromSeveralScopesUsingPropertyWrappers() throws {
        let container = try Container { builder in
            builder.register(injectable: Lime.self)
                .instancePerDependency()
                .as(Fruit.self)
            builder.register(injectable: Ice.self)
                .instancePerDependency()
                .asSelf()
            builder.register(injectable: FruitCooler.self)
                .instancePerDependency()
                .asSelf()
        }
        let childContainer = try container.createChildContainer { builder in
            builder.register(injectable: FreshJuice.self)
                .instancePerDependency()
                .as(Juice.self)
        }

        XCTAssertNoThrow(try childContainer.resolve(FruitCooler.self, withArguments: Argument<Fruit>(Apple())))

        let cooler = try childContainer.resolve(FruitCooler.self, withArguments: Argument<Fruit>(Apple()))

        XCTAssert(cooler.fruit is Apple)
        XCTAssert(cooler.juice.fruit is Lime)
    }
    
    func testInjectsNilForWrappedOptionalPropertyWhenServiceIsNotRegistered() throws {
        let container = try Container { builder in
            builder.register(injectable: Tuna.self)
                .instancePerDependency()
                .asSelf()
            builder.register(injectable: Cucumber.self)
                .instancePerDependency()
                .asSelf()
            builder.register(injectable: Mayo.self)
                .instancePerDependency()
                .asSelf()
            builder.register(injectable: SushiRoll.self)
                .instancePerDependency()
                .asSelf()
        }
        
        let sushiRoll = try container.resolve(SushiRoll.self)
        
        XCTAssertNil(sushiRoll.omelette)
    }
}
