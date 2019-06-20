import XCTest
@testable import blaze

final class SingleInstanceDynamicRegistrationsTests: XCTestCase {
    func testRegistersAndResolvesSingleInstanceService() throws {
        let container = Container { builder in
            builder.register(injectable: Apple.self)
                .singleInstance()
                .as(Fruit.self)
        }
        
        XCTAssertNoThrow(try container.resolve(Fruit.self))
        
        let apple = try container.resolve(Fruit.self)
        
        XCTAssert(apple is Apple)
    }
    
    func testReturnsOneInstanceForSingleInstanceService() throws {
        let container = Container { builder in
            builder.register(injectable: Apple.self)
                .singleInstance()
                .as(Fruit.self)
        }
        
        let firstFruit = try container.resolve(Fruit.self) as AnyObject?
        let secondFruit = try container.resolve(Fruit.self) as AnyObject?

        XCTAssert(firstFruit === secondFruit)
    }
    
    func testReturnsOneInstanceForSingleInstanceResolvedAsDifferentService () throws {
        let container = Container { builder in
            builder.register(injectable: Apple.self)
                .singleInstance()
                .as(Fruit.self)
                .asSelf()
        }
        
        let fruit = try container.resolve(Fruit.self) as AnyObject
        let apple = try container.resolve(Apple.self) as AnyObject
        
        XCTAssert(fruit === apple)
    }
    
    func testRegisterAndResolveSingleInstanceWithOneDependency() throws {
        let container = Container { builder in
            builder.register(injectable: AppleGarden.self)
                .singleInstance()
                .asSelf()
            
            builder.register(injectable: AppleFarmer.self)
                .singleInstance()
                .asSelf()
                .as(FruitProvider.self)
        }
        
        XCTAssertNoThrow(try container.resolve(AppleFarmer.self))
        XCTAssertNoThrow(try container.resolve(FruitProvider.self))
        XCTAssertNoThrow(try container.resolve(AppleGarden.self))

        let appleFarm = try container.resolve(AppleFarmer.self)
        let fruitProvider = try container.resolve(FruitProvider.self)
        let appleTree = try container.resolve(AppleGarden.self)
        
        XCTAssert(fruitProvider as AnyObject === appleFarm as AnyObject)
        XCTAssert(appleFarm.tree as AnyObject === appleTree as AnyObject)
    }
    
    func testRegisterAndResolveSingleInstanceWithTwoDependencies() throws {
        let container = Container { builder in
            builder.register(injectable: AppleGarden.self)
                .singleInstance()
                .asSelf()
            
            builder.register(injectable: AppleFarmer.self)
                .singleInstance()
                .as(FruitProvider.self)
            
            builder.register(injectable: JuiceFactory.self)
                .singleInstance()
                .asSelf()
            
            builder.register(injectable: CoolAndDryPlace.self)
                .singleInstance()
                .as(JuiceStorage.self)
        }
        
        XCTAssertNoThrow(try container.resolve(JuiceFactory.self))
        
        let juiceFactory = try container.resolve(JuiceFactory.self)
        
        XCTAssert(juiceFactory.fruitProvider is AppleFarmer)
        XCTAssert(juiceFactory.storage is CoolAndDryPlace)
    }
    
    func testRegisterAndResolveSingleInstanceWithThreeDependencies() throws {
        let container = Container { builder in
            builder.register(injectable: ServiceWithThreeParameters.self)
                .singleInstance()
                .asSelf()
            
            builder.register(injectable: FirstDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: SecondDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: ThirdDependency.self)
                .singleInstance()
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(ServiceWithThreeParameters.self))
    }
    
    func testRegisterAndResolveSingleInstanceWithFourDependencies() throws {
        let container = Container { builder in
            builder.register(injectable: ServiceWithFourParameters.self)
                .singleInstance()
                .asSelf()
            
            builder.register(injectable: FirstDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: SecondDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: ThirdDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: FourthDependency.self)
                .singleInstance()
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(ServiceWithFourParameters.self))
    }

    func testRegisterAndResolveSingleInstanceWithFiveDependencies() throws {
        let container = Container { builder in
            builder.register(injectable: ServiceWithFiveParameters.self)
                .singleInstance()
                .asSelf()
            
            builder.register(injectable: FirstDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: SecondDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: ThirdDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: FourthDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: FithDependency.self)
                .singleInstance()
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(ServiceWithFiveParameters.self))
    }
    
    func testRegisterAndResolveSingleInstanceWithCustomDependencies() throws {
        let container = Container { builder in
            builder.register(injectable: ServiceWithCustomParameters.self)
                .singleInstance()
                .asSelf()
            
            builder.register(injectable: FirstDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: SecondDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: ThirdDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: FourthDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: FithDependency.self)
                .singleInstance()
                .asSelf()
            builder.register(injectable: SixthDependency.self)
                .singleInstance()
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(ServiceWithCustomParameters.self))
    }
}
