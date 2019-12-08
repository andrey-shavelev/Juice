//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
import Juice

final class AutoFactoriesTests : XCTestCase {
    func testCreatesComponentWithoutParameters() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                .instancePerDependency()
                .as(Fruit.self)
        }
        
        let fruitFactory = try container.resolve(Factory<Fruit>.self)
        let fruit = try fruitFactory.create()
        
        XCTAssert(fruit is Apple)
    }
    
    func testCreatesComponentWithOnParameter() throws {
        let container = try Container { builder in
            builder.register(injectable: FreshJuice.self)
                .instancePerDependency()
                .as(Juice.self)
        }
        
        let juiceFactory = try container.resolve(FactoryWithParameter<Fruit, Juice>.self)
        let orangeJuice = try juiceFactory.create(Orange())
        
        XCTAssert(orangeJuice.fruit is Orange)
    }
    
    func testCreatesComponentWithTwoParameters() throws {
        let container = try Container { builder in
            builder.register(injectable: Compote.self)
                .instancePerDependency()
                .asSelf()
        }
        
        let compoteFactory = try container.resolve(FactoryWithTwoParameters<Fruit, Spice, Compote>.self)
        
        let appleCompote = try compoteFactory.create(Apple(), Ginger())
        
        XCTAssert(appleCompote.fruit is Apple)
        XCTAssert(appleCompote.spice is Ginger)
    }
    
    func testCreatesComponentWithThreeParameters() throws {
        let container = try Container { builder in
            builder.register(injectable: FreshMorningSmoothie.self)
                .instancePerDependency()
                .asSelf()
        }
        
        let smoothieFactory = try container.resolve(FactoryWithThreeParameters<Fruit, Berry, Juice, FreshMorningSmoothie>.self)
        let smoothie = try smoothieFactory.create(Banana(), Strawberry(), FreshJuice(Apple()))
        
        XCTAssert(smoothie.berry is Strawberry)
        XCTAssert(smoothie.fruit is Banana)
        XCTAssert(smoothie.juice.fruit is Apple)
    }
    
    func testCreatesComponentWithFourParameters() throws {
        let container = try Container { builder in
            builder.register(injectable: Cocktail.self)
                .instancePerDependency()
                .asSelf()
        }
        
        let cocktailFactory = try container.resolve(FactoryWithFourParameters<Juice, Lime, Sweetener, Water, Cocktail>.self)
        let cocktail = try cocktailFactory.create(FreshJuice(Apple()), Lime(), Sugar(), SodaWater())
        
        XCTAssert(cocktail.fruitJuice.fruit is Apple)
        XCTAssert(cocktail.sweetener is Sugar)
        XCTAssert(cocktail.water is SodaWater)
    }
}
