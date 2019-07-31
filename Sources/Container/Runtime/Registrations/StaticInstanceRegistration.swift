//
//  StaticInstanceRegistration.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/06/2019.
//

class StaticInstanceRegistration<Type>: ServiceRegistration {
    // TODO must be unowned with choice
    let instance: Type
    
    init(instance: Type) {
        self.instance = instance
    }

    func resolveServiceInstance(storageLocator: InstanceStorageLocator, scopeLocator: ResolutionScopeLocator) throws -> Any {
        return instance
    }
}
