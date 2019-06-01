//
//  Protocols.swift
//  blaze
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
