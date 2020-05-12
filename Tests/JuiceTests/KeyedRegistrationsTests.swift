//
//  File.swift
//  
//
//  Created by Andrey Shavelev on 04/05/2020.
//

import XCTest
import Juice

final class KeyedRegistrationsTests : XCTestCase {
    
    func testCanRegisterAndResolveKeyedService() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                .instancePerContainer()
                .as(Fruit.self)
            builder.register(injectable: Banana.self)
                .instancePerDependency()
                .as(Fruit.self, withKey: 42)
        }
        
        let apple = try container.resolve(Fruit.self)
        let banana = try container.resolve(Fruit.self, forKey: 42)
        
        XCTAssertTrue(apple is Apple)
        XCTAssertTrue(banana is Banana)
    }
    
    func testThrowsWhenTryingToResolveServiceWithoutAKeyThatWasRegisteredOnlyByKey() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                .instancePerDependency()
                .as(Fruit.self, withKey: "red and juicy")
        }
        
        XCTAssertThrowsError(
                try container.resolve(Fruit.self)
            )
    }
    
    func testResolvesAllServicesRegisteredForSpecifiedKey() throws {
        let container = try Container { builder in
            builder.register(injectable: Pear.self)
                .instancePerDependency()
                .as(Fruit.self, withKey: "for juice")
            builder.register(injectable: Banana.self)
                .instancePerContainer()
                .as(Fruit.self)
            builder.register(injectable: Apple.self)
                .instancePerDependency()
                .as(Fruit.self, withKey: "for juice")
        }
        
        let fruits = try container.resolveAll(of: Fruit.self, forKey: "for juice")
        
        XCTAssertTrue(fruits[0] is Pear)
        XCTAssertTrue(fruits[1] is Apple)
    }
    
    func testResolvesKeyedServiceWithParameter() throws {
        let container = try Container { builder in
            builder.register(injectable: FreshJuice.self)
                .instancePerDependency()
                .as(Juice.self, withKey: "fresh")
        }
        
        let freshAppleJuice = try container.resolve(Juice.self, forKey: "fresh", withArguments: Argument<Fruit>(Apple()))
        
        XCTAssertTrue(freshAppleJuice.fruit is Apple)
    }
    
    func testResolvesOptionalKeyedService() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                .instancePerDependency()
                .as(Fruit.self, withKey: "some key")
        }
        
        let someApple = try container.resolveOptional(Fruit.self, forKey: "some key")
        let otherApple = try container.resolveOptional(Fruit.self, forKey: "other key")
        
        XCTAssertTrue(someApple is Apple)
        XCTAssertNil(otherApple)
    }
    
    func testResolvesOptionalKeyedServiceWithParameter() throws {
        let container = try Container { builder in
            builder.register(injectable: FreshJuice.self)
                .instancePerDependency()
                .as(Juice.self, withKey: "fresh")
        }
        
        let freshAppleJuice = try container.resolveOptional(Juice.self, forKey: "fresh", withArguments: Argument<Fruit>(Apple()))
        let staleAppleJuice = try container.resolveOptional(Juice.self, forKey: "stale", withArguments: Argument<Fruit>(Apple()))
        
        XCTAssertTrue(freshAppleJuice?.fruit is Apple)
        XCTAssertNil(staleAppleJuice)
    }
}
