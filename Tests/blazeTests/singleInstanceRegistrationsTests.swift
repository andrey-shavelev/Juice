import XCTest
@testable import blaze

final class singleInstanceRegistrationsTests: XCTestCase {
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
                .asSelf()
                .singleInstance()
        }
        
        let fruit = try container.resolve(Fruit.self) as AnyObject
        let apple = try container.resolve(Apple.self) as AnyObject
        
        XCTAssert(fruit === apple)
    }
    
    func testRegisterAndResolveSingleInstanceWithOneDependency() throws {
        let container = Container.build { builder in
            builder.register(singleInstance: AppleGarden.self)
                .asSelf()
            
            builder.register(singleInstance: AppleFarmer.self)
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
        let container = Container.build { builder in
            builder.register(singleInstance: AppleGarden.self)
                .asSelf()
            
            builder.register(singleInstance: AppleFarmer.self)
                .as(FruitProvider.self)
            
            builder.register(singleInstance: JuiceFactory.self)
                .asSelf()
            
            builder.register(singleInstance: CoolAndDryPlace.self)
                .as(JuiceStorage.self)
        }
        
        XCTAssertNoThrow(try container.resolve(JuiceFactory.self))
        
        let juiceFactory = try container.resolve(JuiceFactory.self)
        
        XCTAssert(juiceFactory.fruitProvider is AppleFarmer)
        XCTAssert(juiceFactory.storage is CoolAndDryPlace)
    }
    
    func testRegisterAndResolveSingleInstanceWithThreeDependencies() throws {
        let container = Container.build { builder in
            builder.register(singleInstance: ServiceWithThreeParameters.self)
                .asSelf()
            
            builder.register(singleInstance: FirstDependency.self)
                .asSelf()
            builder.register(singleInstance: SecondDependency.self)
                .asSelf()
            builder.register(singleInstance: ThirdDependency.self)
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(ServiceWithThreeParameters.self))
    }
    
    func testRegisterAndResolveSingleInstanceWithFourDependencies() throws {
        let container = Container.build { builder in
            builder.register(singleInstance: ServiceWithFourParameters.self)
                .asSelf()
            
            builder.register(singleInstance: FirstDependency.self)
                .asSelf()
            builder.register(singleInstance: SecondDependency.self)
                .asSelf()
            builder.register(singleInstance: ThirdDependency.self)
                .asSelf()
            builder.register(singleInstance: FourthDependency.self)
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(ServiceWithFourParameters.self))
    }

    func testRegisterAndResolveSingleInstanceWithFiveDependencies() throws {
        let container = Container.build { builder in
            builder.register(singleInstance: ServiceWithFiveParameters.self)
                .asSelf()
            
            builder.register(singleInstance: FirstDependency.self)
                .asSelf()
            builder.register(singleInstance: SecondDependency.self)
                .asSelf()
            builder.register(singleInstance: ThirdDependency.self)
                .asSelf()
            builder.register(singleInstance: FourthDependency.self)
                .asSelf()
            builder.register(singleInstance: FithDependency.self)
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(ServiceWithFiveParameters.self))
    }
    
    func testRegisterAndResolveSingleInstanceWithCustomDependencies() throws {
        let container = Container.build { builder in
            builder.register(singleInstance: ServiceWithCustomParameters.self)
                .asSelf()
            
            builder.register(singleInstance: FirstDependency.self)
                .asSelf()
            builder.register(singleInstance: SecondDependency.self)
                .asSelf()
            builder.register(singleInstance: ThirdDependency.self)
                .asSelf()
            builder.register(singleInstance: FourthDependency.self)
                .asSelf()
            builder.register(singleInstance: FithDependency.self)
                .asSelf()
            builder.register(singleInstance: SixthDependency.self)
                .asSelf()
        }
        
        XCTAssertNoThrow(try container.resolve(ServiceWithCustomParameters.self))
    }
}
