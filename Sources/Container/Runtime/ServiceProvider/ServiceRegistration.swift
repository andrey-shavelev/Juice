//
//  ServiceRegistration.swift
//  blaze
//
//  Created by Andrey Shavelev on 25/05/2019.
//

class ServiceRegistration {
    
    let factory: ImplementorFactory
    var instance: Any?
    
    init(factory: ImplementorFactory) {
        self.factory = factory
    }
    
    func resolve(resolveDependenciesFrom temporaryResolver: TemporaryResolver) throws -> Any {
        
        if let notNullInstance = instance
        {
            return notNullInstance
        }
        
        instance = try factory.create(resolveDependenciesFrom: temporaryResolver)
        return instance!
    }
}
