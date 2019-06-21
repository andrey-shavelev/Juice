//
//  StaticInstanceRegistration.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/06/2019.
//

class StaticInstanceRegistration<Type>: ServiceRegistration {
    
    let instance: Type
    
    init(instance: Type) {
        self.instance = instance
    }
    
    func resolveServiceInstance(withDependenciesResolvedFrom scope: Scope) throws -> Any {
        return instance
    }  
    
}
