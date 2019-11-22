//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
import Juice

final class LazyResolveTests : XCTestCase {
    
    func testCanResolveLazy() throws {
        let container = try Container { builder in
            builder.register(injectable: Orange.self)
                .singleInstance()
                .as(Fruit.self)
        }
        
        var lazyOrange = try container.resolve(Lazy<Fruit>.self)
        let orange = try container.resolve(Fruit.self)
        
        XCTAssert(try lazyOrange.getValue() as! Orange === orange as! Orange)
    }
    
    func testLazyInstanceIsNotCreatedUntilValueIsRead() throws {
        var factoryWasCalled = false
        
        let container = try Container { builder in
            builder.register(factory: { scope -> Apple in
                factoryWasCalled = true
                return Apple()
            })
                .instancePerDependency()
                .as(Fruit.self)
        }
        
        var lazyApple = try container.resolve(Lazy<Fruit>.self)
        
        XCTAssertFalse(factoryWasCalled)
        
        let _ = try lazyApple.getValue()
        
        XCTAssertTrue(factoryWasCalled)
    }
    
    func testCanBreakComponentCycleWithLazy() throws {
        let container = try Container { builder in
            builder.register(injectable: LazyEgg.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: LazyChicken.self)
                .singleInstance()
                .asSelf()
        }
        
        let lazyChicken = try container.resolve(LazyChicken.self)
        let lazyEgg = try container.resolve(LazyEgg.self)
        
        XCTAssert(lazyEgg.chicken === lazyChicken)
        XCTAssert(try lazyChicken.egg.getValue() === lazyEgg)
    }
}
