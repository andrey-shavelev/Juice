//
//  Classes.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 21/05/2019.
//
import blaze

protocol Fruit {
    
}

protocol FruitProvider {
    
    func getFruit() -> Fruit
    
}

protocol JuiceStorage {
    func put(juice: SingleFuitJuice)
    func get() -> SingleFuitJuice?
}

protocol SingleFuitJuice {
    
    func getIngridients() -> [Fruit]
    
}

class Apple: Fruit, Injectable {
    
    required init() {
    }    
}

class Orange: Fruit, Injectable {
    
    required init() {
    }
}

class Banana: Fruit, Injectable {
    
    required init() {
    }
}

class AppleGarden : Injectable{
    
    required init() {
    }
    
    func yield() -> Apple {
        return Apple()
    }
}

class AppleFarmer: FruitProvider, InjectableWithParameter {
    let tree: AppleGarden
    
    required init(_ tree: AppleGarden) {
        self.tree = tree
    }
    
    func getFruit() -> Fruit {
        return tree.yield()
    }
}

class CoolAndDryPlace: JuiceStorage, Injectable {
    var juice: SingleFuitJuice?
    
    required init() {
    }
    
    func put(juice: SingleFuitJuice) {
        self.juice = juice
    }
    
    func get() -> SingleFuitJuice? {
        let juice = self.juice
        self.juice = nil
        return juice
    }
}

class JuiceFactory: InjectableWithTwoParameters {
    let fruitProvider: FruitProvider
    let storage: JuiceStorage
    
    required init(_ fruitProvider: FruitProvider, _ juiceStorage: JuiceStorage) {
        self.fruitProvider = fruitProvider
        self.storage = juiceStorage
    }
}

class FruitBasket : Injectable {
    
    var apple: Apple!
    var orange: Orange?
    
    required init() {
    }
}

class FreshJuice : InjectableWithParameter, SingleFuitJuice {    
    let fruit: Fruit
    
    required init(_ fruit: Fruit) {
        self.fruit = fruit
    }
    
    func getIngridients() -> [Fruit] {
        return [fruit]
    }
}

class Chocolate : InjectableWithParameter {
    
    enum Kind {
        case milk
        case dark
        case white
    }
    
    let kind: Kind
    
    required init(_ kind: Kind) {
        self.kind = kind
    }
}

protocol Berry {
}

class Raspbery: Berry, Injectable {
    required init() {
    }
}

class Blueberry: Berry, Injectable {
    required init() {
    }
}

class Strawberry: Berry, Injectable {
    required init() {
    }
}

class Water {
    let temperatureCelsius: Int
    
    init(temperatureCelsius: Int) {
        self.temperatureCelsius = temperatureCelsius
    }
}

class Smothy: InjectableWithThreeParameters {    
    let water: Water
    let fruit: Fruit
    let berry: Berry
    
    required init(_ fruit: Fruit, _ berry: Berry, _ water: Water) {
        self.berry = berry
        self.fruit = fruit
        self.water = water
    }
}

enum Country {
    case Japan
    case USA
}

class Pear: Fruit, InjectableWithParameter {
    
    let countryOfOrigin: Country
    
    required init(_ countryOfOrigin: Country) {
        self.countryOfOrigin = countryOfOrigin
    }
}

class PackedJuice : InjectableWithTwoParameters {
    let fruit: Fruit
    let countryOfOrigin: Country
    
    required init(_ fruit: Fruit, _ countryOfOrigin: Country) {
        self.fruit = fruit
        self.countryOfOrigin = countryOfOrigin
    }
    
    func getIngridients() -> [Fruit] {
        return [fruit]
    }
}

class HomeMadeJuice : CustomInjectable {
    let fruit: Fruit
    
    required init(receiveDependenciesFrom scope: Scope) throws {
        fruit = try scope.resolve(Fruit.self)
    }
}
