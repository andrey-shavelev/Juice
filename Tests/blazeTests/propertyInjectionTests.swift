//
//  propertyInjectionTests.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 08/06/2019.
//
import XCTest
@testable import blaze

final class propertyInjectionTests: XCTestCase {
    
    func testInjectsSingleInstancesIntoProperty() throws {
        let container = Container.build { builder in
            builder.register(singleInstance: Apple.self).asSelf()
            builder.register(singleInstance: Orange.self).asSelf()
            builder.register(singleInstance: FruitBasket.self)
                .asSelf()
                .injectDependency(into: \.apple)
                .injectDependency(into: \.orange)
            
        }
        
        XCTAssertNoThrow(try container.resolve(FruitBasket.self))
        
        let basket = try container.resolve(FruitBasket.self)
        let apple = try container.resolve(Apple.self)
        let orange = try container.resolve(Orange.self)
        
        XCTAssert(apple === basket.apple)
        XCTAssert(orange === basket.orange)
    }
}
