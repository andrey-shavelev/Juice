//
//  propertyInjectionTests.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 08/06/2019.
//

import XCTest
@testable import blaze

final class PropertyInjectionTests: XCTestCase {

    func testInjectsSingleInstancesIntoProperty() throws {
        let container = try Container { builder in
            builder.register(injectable: Pear.self)
                    .singleInstance()
                    .asSelf()
                    .as(Fruit.self)
            builder.register(injectable: Ginger.self)
                    .singleInstance()
                    .as(Spice.self)
            builder.register(injectable: Jam.self)
                    .singleInstance()
                    .asSelf()
                    .injectDependency(into: \.fruit)
                    .injectDependency(into: \.spice)
        }

        XCTAssertNoThrow(try container.resolve(Jam.self))

        let jam = try container.resolve(Jam.self)
        let pear = try container.resolve(Pear.self)

        XCTAssert(pear === jam.fruit as! Pear)
        XCTAssert(jam.spice is Ginger)
    }
}
