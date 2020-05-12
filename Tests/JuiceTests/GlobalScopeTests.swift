//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
import Juice

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
}
