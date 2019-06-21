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
    func put(juice: Juice)
    func get() -> Juice?
}

protocol Juice {
    
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

class Pear: Fruit, Injectable {
    
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
    var juice: Juice?
    
    required init() {
    }
    
    func put(juice: Juice) {
        self.juice = juice
    }
    
    func get() -> Juice? {
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

class FreshJuice : InjectableWithParameter, Juice {    
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
