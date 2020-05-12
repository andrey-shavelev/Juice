//
//  File.swift
//  
//
//  Created by Andrey Shavelev on 03/05/2020.
//

class MultiServiceRegistration: ServiceRegistration {
    
    private var innerRegistrations: [ServiceRegistration]
    private var lastRegistration: ServiceRegistration
    
    init(firstRegistration: ServiceRegistration,
         secondRegistration: ServiceRegistration) {
        lastRegistration = secondRegistration
        innerRegistrations = [firstRegistration, secondRegistration]
    }
    
    func add(registration: ServiceRegistration){
        lastRegistration = registration
        innerRegistrations.append(registration)
    }
    
    func resolveServiceInstance(storageLocator: InstanceStorageLocator, scopeLocator: ResolutionScopeLocator) throws -> Any {
        return try lastRegistration.resolveServiceInstance(storageLocator: storageLocator, scopeLocator: scopeLocator)
    }
    
    func resolveAllServiceInstances(storageLocator: InstanceStorageLocator, scopeLocator: ResolutionScopeLocator) throws -> [Any] {
        try innerRegistrations.map {
            try $0.resolveServiceInstance(storageLocator: storageLocator, scopeLocator: scopeLocator)
        }
    }
}
