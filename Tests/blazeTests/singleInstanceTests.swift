import XCTest
@testable import blaze

final class singleInstanceTests: XCTestCase {
    func testRegistersAndResolvesSingleInstanceService() throws {
        let container = Container.build { builder in
            builder.register(type: Apple.self)
                .as(Fruit.self)
                .singleInstance()
        }
        
        XCTAssertNoThrow(try container.resolve(Fruit.self))
        
        let apple = try container.resolve(Fruit.self)
        
        XCTAssert(apple is Apple)
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
        
        let fruit = try container.resolve(Fruit.self) as AnyObject
        let apple = try container.resolve(Apple.self) as AnyObject
        
        XCTAssert(fruit === apple)
    }
    
    func testRegisterAndResolveSingleInstanceWithOneDependency() throws {
        let container = Container.build { builder in
            builder.register(singleInstance: AppleTree.self)
                .as(AppleTree.self)
            
            builder.register(singleInstance: AppleFarm.self)
                .as(AppleFarm.self)
                .as(FruitProvider.self)
        }
        
        XCTAssertNoThrow(try container.resolve(AppleFarm.self))
        XCTAssertNoThrow(try container.resolve(FruitProvider.self))
        XCTAssertNoThrow(try container.resolve(AppleTree.self))

        let appleFarm = try container.resolve(AppleFarm.self)
        let fruitProvider = try container.resolve(FruitProvider.self)
        let appleTree = try container.resolve(AppleTree.self)
        
        XCTAssert(fruitProvider as AnyObject === appleFarm as AnyObject)
        XCTAssert(appleFarm.tree as AnyObject === appleTree as AnyObject)
    }
    
    func testRegisterAndResolveSingleInstanceWithTwoDependencies() throws {
        let container = Container.build { builder in
            builder.register(singleInstance: AppleTree.self)
                .as(AppleTree.self)
            
            builder.register(singleInstance: AppleFarm.self)
                .as(FruitProvider.self)
            
            builder.register(singleInstance: JuiceFactory.self)
                .as(JuiceFactory.self)
            
            builder.register(singleInstance: CoolAndDryPlace.self)
                .as(JuiceStorage.self)
        }
        
        XCTAssertNoThrow(try container.resolve(JuiceFactory.self))
        
        let juiceFactory = try container.resolve(JuiceFactory.self)
        
        XCTAssert(juiceFactory.fruitProvider is AppleFarm)
        XCTAssert(juiceFactory.storage is CoolAndDryPlace)
    }

    static var allTests = [
        ("testRegistersAndResolvesSingleInstanceService",
         "testReturnsOneInstanceForSingleInstanceService",
         "testReturnsOneInstanceForSingleInstanceResolvedAsDifferentService",
         "testRegisterAndResolveSingleInstanceWithOneDependency"),
    ]
}
