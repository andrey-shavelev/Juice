//
//  instancePerDependencyRegistrationsTests.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 14/06/2019.
//

import XCTest
@testable import blaze

final class instancePerDependencyRegistrationsTests: XCTestCase {
    func testRegistersAndResolvesSingleInstanceService() throws {
        let container = Container.build { builder in
            builder.register(type: Apple.self)
                .instancePerDependency()
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(Apple.self))
        
        let firstApple = try container.resolve(Apple.self)
        let secondApple = try container.resolve(Apple.self)

        XCTAssert(firstApple !== secondApple)
    }
}
