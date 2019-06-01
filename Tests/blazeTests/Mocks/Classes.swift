//
//  Classes.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 21/05/2019.
//
import blaze

class Apple: Fruit, Injectable {
    
    required init() {
    }    
}

class AppleTree : Injectable{
    
    required init() {
    }
    
    func yield() -> Apple {
        return Apple()
    }
}

class AppleFarm: FruitProvider, InjectableWithParameter {
    let tree: AppleTree
    
    required init(_ tree: AppleTree) {
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
