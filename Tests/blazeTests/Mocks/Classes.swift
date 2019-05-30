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
