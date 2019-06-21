//
//  AutoFactoryTests.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 17/06/2019.
//

import XCTest
@testable import blaze

final class ParameterizedResolutionTests: XCTestCase {

    func testPassesParameterToInstancePerDependency() throws {
        let container = Container { builder in
            
            builder.register(injectable: Chocolate.self)
                .instancePerDependency()
                .asSelf()
            builder.register(autofactoryFor: Chocolate.self)
        }
        
        XCTAssertNoThrow(try container.resolve(Chocolate.self, withParameters: Chocolate.Kind.milk))
        
        let darkChocolate = try container.resolve(Chocolate.self, withParameters: Chocolate.Kind.dark)
        let milkCocolate = try container.resolve(Chocolate.self, withParameters: Chocolate.Kind.milk)
        
        XCTAssertEqual(Chocolate.Kind.dark, darkChocolate.kind)
        XCTAssertEqual(Chocolate.Kind.milk, milkCocolate.kind)
    }
    
}
