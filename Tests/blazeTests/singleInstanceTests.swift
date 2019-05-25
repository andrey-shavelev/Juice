import XCTest
@testable import blaze

final class singleInstanceTests: XCTestCase {
    func testRegistersAndResolvesSingleInstanceService() throws {
        let container = Container.build { builder in
            builder.register(type: Apple.self)
                .as(Fruit.self)
                .singleInstance()
        }
        
        let fruit = try container.resolve(Fruit.self)
        
        XCTAssert(fruit is Apple)
    }
    
    func testReturnsOneInstanceForSingleInstanceService() throws {
        let container = Container.build { builder in
            builder.register(type: Apple.self)
                .as(Fruit.self)
                .singleInstance()
        }
        
        let firstFruit = try container.resolve(Fruit.self) as AnyObject?
        let secondFruit = try container.resolve(Fruit.self) as AnyObject?

        XCTAssert(firstFruit === secondFruit)
    }
    
    func testReturnsOneInstanceForSingleInstanceResolvedAsDifferentService () throws {
        let container = Container.build { builder in
            builder.register(type: Apple.self)
                .as(Fruit.self)
                .as(Apple.self)
                .singleInstance()
        }
        
        let fruit = try container.resolve(Fruit.self) as AnyObject?
        let apple = try container.resolve(Apple.self) as AnyObject?
        
        XCTAssert(fruit === apple)
    }

    static var allTests = [
        ("registersAndResolvesSingleInstanceService", testRegistersAndResolvesSingleInstanceService),
    ]
}
