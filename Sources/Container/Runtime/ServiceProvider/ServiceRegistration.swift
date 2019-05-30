//
//  ServiceRegistration.swift
//  blaze
//
//  Created by Andrey Shavelev on 25/05/2019.
//

class ServiceRegistration {
    
    let factory: InstanceFactory
    var instance: Any?
    
    init(factory: InstanceFactory) {
        self.factory = factory
    }
    
    func resolve(resolveDependenciesFrom temporaryResolver: ContextResolver) throws -> Any {
        
        if let notNullInstance = instance
        {
            return notNullInstance
        }
        
        instance = try factory.create(resolveDependenciesFrom: temporaryResolver)
        return instance!
    }
}
