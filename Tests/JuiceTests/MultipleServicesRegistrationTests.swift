//
//  File.swift
//  
//
//  Created by Andrey Shavelev on 03/05/2020.
//

import XCTest
import Juice

final class MultipleServicesRegistrationTests: XCTestCase {
    
    func testRegistersServicesFromModule() throws {
        let container = try Container { builder in
            builder.register(value: TestEnum.one)
                .as(TestEnum.self)
            builder.register(value: TestEnum.two)
                .as(TestEnum.self)
            builder.register(value: TestEnum.three)
                .as(TestEnum.self)
        }
        
        let expectedValues = [TestEnum.one, .two, .three]
        let allValues = try container.resolveAll(of: TestEnum.self)
        
        XCTAssertEqual(expectedValues, allValues)
    }
    
    func testCanRegisterOneComponentSeveralTimes() throws {
        let container = try Container { builder in
            builder.register(value: TestEnum.one)
                .as(TestEnum.self)
            builder.register(value: TestEnum.one)
                .as(TestEnum.self)
        }
        
        let expectedValues = [TestEnum.one, .one]
        let actualValues = try container.resolveAll(of: TestEnum.self)
        
        XCTAssertEqual(expectedValues, actualValues)
    }
    
    func testProvidesSameParametersToAllComponents() throws {
        let container = try Container { builder in
            builder.register(injectable: FreshJuice.self)
                .instancePerDependency()
                .as(Drink.self)
            builder.register(injectable: FreshMorningSmoothie.self)
                .instancePerDependency()
                .as(Drink.self)
            builder.register(injectable: Compote.self)
                .instancePerDependency()
                .as(Drink.self)
            builder.register(injectable: Apple.self)
                .instancePerDependency()
                .as(Fruit.self)
        }
        
        let orangeJuice = FreshJuice(Orange())
        let raspbery = Raspberry()
        let cloves = Cloves()
        
        let actualValues = try container.resolveAll(of: Drink.self,
                                                    withArguments: Argument<Berry>(raspbery), Argument<Juice>(orangeJuice),
        Argument<Spice>(cloves))
        
        let appleJuice = actualValues[0] as! Juice
        let smoothie = actualValues[1] as! Smoothie
        let compote = actualValues[2] as! Compote
        
        XCTAssertTrue(raspbery === smoothie.berry as! Raspberry)
        XCTAssertTrue(orangeJuice === smoothie.juice as! FreshJuice)
        XCTAssertTrue(compote.spice is Cloves)
        XCTAssertTrue(appleJuice.fruit is Apple)
    }
    
    func testCorrectlyHandlesResolveAllFromWithingResolvedComponent() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                .instancePerDependency()
                .as(Fruit.self)
            builder.register(injectable: Orange.self)
                .instancePerDependency()
                .as(Fruit.self)
            builder.register(injectable: Pear.self)
                .instancePerDependency()
                .as(Fruit.self)
            builder.register(injectable: FruitBasket.self)
                .instancePerDependency()
                .asSelf()
        }
        
        let fruitBasket = try container.resolve(FruitBasket.self)
        
        XCTAssertTrue(fruitBasket.fruits[0] is Apple)
        XCTAssertTrue(fruitBasket.fruits[1] is Orange)
        XCTAssertTrue(fruitBasket.fruits[2] is Pear)
    }
    
    func testParrameterOverridesAllContainerRegistrations() throws {
         let container = try Container { builder in
             builder.register(injectable: Apple.self)
                 .instancePerDependency()
                 .as(Fruit.self)
             builder.register(injectable: Orange.self)
                 .instancePerDependency()
                 .as(Fruit.self)
             builder.register(injectable: Pear.self)
                 .instancePerDependency()
                 .as(Fruit.self)
             builder.register(injectable: FruitBasket.self)
                 .instancePerDependency()
                 .asSelf()
         }
         
        let banana = Banana()
        
        let fruitBasket = try container.resolve(FruitBasket.self,
                                                withArguments: Argument<Fruit>(banana))
         
        XCTAssertEqual(1, fruitBasket.fruits.count)
        XCTAssertTrue(fruitBasket.fruits[0] as! Banana === banana)
     }
    
    func testResolvesAllParametersWhenHaveMultipleForSameType() throws {
        let container = try Container { builder in
             builder.register(injectable: Apple.self)
                 .instancePerDependency()
                 .as(Fruit.self)
             builder.register(injectable: Orange.self)
                 .instancePerDependency()
                 .as(Fruit.self)
             builder.register(injectable: Pear.self)
                 .instancePerDependency()
                 .as(Fruit.self)
             builder.register(injectable: FruitBasket.self)
                 .instancePerDependency()
                 .asSelf()
         }
         
        let banana: Banana = Banana()
        let pear: Pear = Pear()
        
        let fruitBasket = try container.resolve(FruitBasket.self,
                                                withArguments: Argument<Fruit>(banana),
                                                Argument<Fruit>(pear))
         
        XCTAssertEqual(2, fruitBasket.fruits.count)
        
        XCTAssertTrue(fruitBasket.fruits[0] as! Banana === banana)
        XCTAssertTrue(fruitBasket.fruits[1] as! Pear === pear)
    }
    
    func testResolvesAllRegisteredServicesWhenInjectingArray() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                .instancePerDependency()
                .as(Fruit.self)
            builder.register(injectable: Orange.self)
                .instancePerDependency()
                .as(Fruit.self)
            builder.register(injectable: Pear.self)
                .instancePerDependency()
                .as(Fruit.self)
            builder.register(injectable: FruitBasketWithArray.self)
                .instancePerDependency()
                .asSelf()
        }
        
        let fruitBasket = try container.resolve(FruitBasketWithArray.self)
        
        XCTAssertTrue(fruitBasket.fruits[0] is Apple)
        XCTAssertTrue(fruitBasket.fruits[1] is Orange)
        XCTAssertTrue(fruitBasket.fruits[2] is Pear)
    }
    
    func testParametersPassedIndividuallyDoNotMatchArray() throws {
        let container = try Container { builder in
             builder.register(injectable: Apple.self)
                 .instancePerDependency()
                 .as(Fruit.self)
             builder.register(injectable: Orange.self)
                 .instancePerDependency()
                 .as(Fruit.self)
             builder.register(injectable: Pear.self)
                 .instancePerDependency()
                 .as(Fruit.self)
             builder.register(injectable: FruitBasketWithArray.self)
                 .instancePerDependency()
                 .asSelf()
         }
         
        let banana: Banana = Banana()
        let pear: Pear = Pear()
        
        let fruitBasket = try container.resolve(FruitBasketWithArray.self,
                                                withArguments: Argument<Fruit>(banana),
                                                Argument<Fruit>(pear))
         
        XCTAssertEqual(3, fruitBasket.fruits.count)
        
        XCTAssertTrue(fruitBasket.fruits[0] is Apple)
        XCTAssertTrue(fruitBasket.fruits[1] is Orange)
        XCTAssertTrue(fruitBasket.fruits[2] is Pear)
    }
    
    func testComponentRegisteredInChildCOntainerOverridesAllParentRegistrations() throws {
        let container = try Container { builder in
            builder.register(injectable: Apple.self)
                .instancePerDependency()
                .as(Fruit.self)
            builder.register(injectable: Orange.self)
                .instancePerDependency()
                .as(Fruit.self)
            builder.register(injectable: Pear.self)
                .instancePerDependency()
                .as(Fruit.self)
            builder.register(injectable: FruitBasketWithArray.self)
                .instancePerDependency()
                .asSelf()
        }
        
        let childContainer = try container.createChildContainer({builder in
            builder.register(injectable: Banana.self)
                .instancePerDependency()
                .as(Fruit.self)
        })
        
        let fruitBasket = try childContainer.resolve(FruitBasketWithArray.self)
        
        XCTAssertEqual(1, fruitBasket.fruits.count)        
        XCTAssertTrue(fruitBasket.fruits[0] is Banana)
    }
}

class FruitBasket: InjectableWithParameter {
    
    let fruits: [Fruit]
    
    required init(_ scope: CurrentScope) throws {
        fruits = try scope.resolveAll(of: Fruit.self)
    }
}

class FruitBasketWithArray: InjectableWithParameter {
    
    let fruits: [Fruit]
    
    required init(_ fruits: [Fruit]) throws {
        self.fruits = fruits
    }
}
