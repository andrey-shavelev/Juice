//
//  InstanceRegistrationTests.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 20/06/2019.
//

import XCTest
@testable import blaze

final class StaticInstanceRegistrationsTests: XCTestCase {
    
    func testRegistrationOfInstance() throws {
        let apple = Apple()
        let container = Container { builder in
            builder.register(instance: apple)
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(Apple.self))
        
        let appleFromContainer = try container.resolve(Apple.self)
        
        XCTAssert(apple === appleFromContainer)
    }
    
}
