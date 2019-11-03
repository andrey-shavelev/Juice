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
    
    func testCreateComponentWithTwoParameters() throws {
        
    }
}
