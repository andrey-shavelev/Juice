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
    
    func testMissingParameterAreResolvedFromScope() throws {
        let container = Container { builder in
            
            builder.register(injectable: Banana.self)
                .instancePerDependency()
                .as(Fruit.self)
            builder.register(injectable: Strawberry.self)
                .instancePerDependency()
                .as(Berry.self)
            builder.register(injectable: Smothy.self)
                .instancePerDependency()
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(Smothy.self, withParameters: Water(temperatureCelsius: 18)))
    }
    
    func testParametersAreUsedOnlyForServiceIntselfAndNotUsedForItsDependencies() throws {
        let container = Container { builder in
            
            builder.register(instance: Country.Japan)
                .asSelf()
            builder.register(injectable: Pear.self)
                .instancePerDependency()
                .as(Fruit.self)
            builder.register(injectable: PackedJuice.self)
                .instancePerDependency()
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(PackedJuice.self, withParameters: Country.USA))
        
        let juice = try container.resolve(PackedJuice.self, withParameters: Country.USA)
        
        XCTAssertEqual(Country.USA, juice.countryOfOrigin)
        XCTAssertEqual(Country.Japan, (juice.fruit as! Pear).countryOfOrigin)
    }
}
