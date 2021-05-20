//
//  File.swift
//  
//
//  Created by Andrey Shavelev on 19/04/2021.
//

import Foundation
import XCTest
import Juice

final class InitRegistrationsTests: XCTestCase {
    
    func testRegistersAndResolvesTypeByItsInitializer() throws {
        let container = try Container { builder in
            builder.register(initializer: SimpleService.init)
                .singleInstance()
                .asSelf()
        }

        XCTAssertNoThrow({ try container.resolve(SimpleService.self) })
    }
    
    func testRegistersAndResolvesTypeByInitializerWithOneParameter() throws {
        let container = try Container { builder in
            builder.register(initializer: ServiceWithOnParameter.init(fruit:))
                .singleInstance()
                .asSelf()
            
            builder.register(injectable: Banana.self)
                .instancePerDependency()
                .as(Fruit.self)
        }

        XCTAssertNoThrow({ try container.resolve(ServiceWithOnParameter.self) })
        
        let service = try container.resolve(ServiceWithOnParameter.self)
        
        XCTAssert(service.fruit is Banana)
    }

    func testRegistersAndResolvesTypeByInitializerWithTwoParameters() throws {
        let container = try Container { builder in
            builder.register(initializer: ServiceWithTwoParameters.init(fruit:spice:))
                .singleInstance()
                .asSelf()
            
            builder.register(injectable: Apple.self)
                .instancePerDependency()
                .as(Fruit.self)
            
            builder.register(injectable: Ginger.self)
                .instancePerDependency()
                .as(Spice.self)
        }

        XCTAssertNoThrow({ try container.resolve(ServiceWithTwoParameters.self) })
        
        let service = try container.resolve(ServiceWithTwoParameters.self)
        
        XCTAssert(service.fruit is Apple)
        XCTAssert(service.spice is Ginger)
    }
}

class SimpleService {
    
}

class ServiceWithOnParameter {
    init(fruit: Fruit) {
        self.fruit = fruit
    }
    
    let fruit: Fruit
}

class ServiceWithTwoParameters {
    internal init(fruit: Fruit, spice: Spice) {
        self.fruit = fruit
        self.spice = spice
    }
    
    let fruit: Fruit
    let spice: Spice
}
