//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
@testable import Juice

final class GlobalScopeTests: XCTestCase {
    
    func testUsesGlobalScopeWhenCreatingObjectWithInjectWrapper() throws {
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
        
        container.setAsGlobalScope()
        
        let fruitIce = FruitIce()

        XCTAssertNotNil(fruitIce.publicApple)
    }
    
    func testSetsAndResignsGlobalScope() throws {
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
        
        container.setAsGlobalScope()
        
        XCTAssertTrue(container === ScopeStack.top as! Container)
        
        container.resignGlobalScope()
        
        XCTAssertNil(ScopeStack.top)
    }
}
