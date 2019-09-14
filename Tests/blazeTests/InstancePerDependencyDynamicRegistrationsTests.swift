//
//  instancePerDependencyRegistrationsTests.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 14/06/2019.
//

import XCTest
import blaze

final class InstancePerDependencyDynamicRegistrationsTests: XCTestCase {
    func testRegistersAndResolvesSingleInstanceService() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                    .instancePerDependency()
                    .asSelf()
        }

        XCTAssertNoThrow(try container.resolve(Apple.self))

        let firstApple = try container.resolve(Apple.self)
        let secondApple = try container.resolve(Apple.self)

        XCTAssert(firstApple !== secondApple)
    }
}
