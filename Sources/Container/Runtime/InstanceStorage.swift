//
//  InstanceStorage.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

import Foundation

class InstanceStorage<TInstance> {
    var instance: TInstance?
    
    func getOrCreate(with factory: ImplementorFactory, resolveDependenciesFrom resolver: TemporaryResolver) throws -> TInstance {
        
        guard let notNullInstance = instance else {
            
            let createdInstance = try factory.create(resolveDependenciesFrom: resolver)
            
            guard let typedInstance = createdInstance as? TInstance else {
                throw ContainerError.invalidType(expectedType: TInstance.self, actualType: type(of: createdInstance))
            }
            
            instance = typedInstance
            
            return typedInstance
        }
        
        return notNullInstance
    }
}
