//
//  AutoFactoryTests.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 17/06/2019.
//

import XCTest
@testable import blaze

final class AutoFactoryRegistrationsTests: XCTestCase {

    func testCanCreateTypeWithAutoFactory() throws {
        let container = Container { builder in
            builder.register(injectable: FreshJuice.self)
                .instancePerDependency()
                .as(Juice.self)
            
            
        }
        
        XCTAssertNoThrow(try container.resolve(Fruit.self))
        
        let apple = try container.resolve(Fruit.self)
        
        XCTAssert(apple is Apple)
    }
    
}
