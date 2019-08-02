//
//  InstancePerScopeTests.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 29/06/2019.
//

import XCTest
@testable import blaze

final class InstancePerScopeRegistrationsTests: XCTestCase {
    
    func testResolvesDifferentInstanceOfInstancePerScopeServiceForChildScope() throws {
        let container = Container { builder in
            builder.register(injectable: Orange.self)
                .instancePerScope()
                .asSelf()
        }
        
        let orangeFromRootScope = try container.resolve(Orange.self)
        let childScope = container.createChildScope()
        let orangeFromChildScope = try childScope.resolve(Orange.self)
        
        XCTAssertFalse(orangeFromRootScope === orangeFromChildScope)
    }
    
    func testResolvesSameInstanceOfInstancePerScopeServiceWhenResolvedFromSameScope() throws {
        let container = Container { builder in
            builder.register(injectable: Orange.self)
                .instancePerScope()
                .asSelf()
        }
        
        let childScope = container.createChildScope()
        
        let orange = try childScope.resolve(Orange.self)
        let sameOrange = try childScope.resolve(Orange.self)
        
        XCTAssertTrue(orange === sameOrange)
    }
}
