//
//  FactoryRegistrationTests.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 22/06/2019.
//

import XCTest
@testable import blaze

final class FactoryRegistrationsTests: XCTestCase {
    func testRegisterAndResolveSingleInstanceCreatedByFactory() throws {
        let container = Container { builder in
            
            builder.register { scope in Apple() }
                .singleInstance()
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(Apple.self))
    }
    
    func testRegisterAndResolveInstancePerDependencyCreatedByFactory() throws {
        let container = Container { builder in
            
            builder.register { scope in Apple() }
                .instancePerDependency()
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(Apple.self))
        
        let firstApple = try container.resolve(Apple.self)
        let secondApple = try container.resolve(Apple.self)
        
        XCTAssert(firstApple !== secondApple)
    }
}
