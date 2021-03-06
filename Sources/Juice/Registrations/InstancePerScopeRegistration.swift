//
// Copyright © 2019 Juice Project. All rights reserved.
//

class InstancePerScopeRegistration<ServiceType>: ServiceRegistration {
    let factory: InstanceFactory
    let scopeKey: ScopeKey
    let storageKey: StorageKey

    init(factory: InstanceFactory, scopeKey: ScopeKey, storageKey: StorageKey) {
        self.factory = factory
        self.scopeKey = scopeKey
        self.storageKey = storageKey
    }

    func resolveServiceInstance(storageLocator: InstanceStorageLocator,
                                scopeLocator: ResolutionScopeLocator) throws -> Any {
        guard let scopeForDependencies = scopeLocator.findScope(matchingKey: scopeKey) else {
            throw ContainerError.scopeNotFound(scopeKey: scopeKey)
        }
        
        guard let storageForInstance = storageLocator.findStorage(matchingKey: scopeKey) else {
            throw ContainerError.scopeNotFound(scopeKey: scopeKey)
        }
        
        ScopeStack.push(scopeForDependencies)
        
        defer {
            ScopeStack.pop()
        }
        
        return try storageForInstance.getOrCreate(
                storageKey: storageKey,
                usingFactory: factory,
                withDependenciesFrom: scopeForDependencies)
    }
}
