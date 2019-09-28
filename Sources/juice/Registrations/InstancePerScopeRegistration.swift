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
            throw ContainerRuntimeError.scopeNotFound(scopeKey: scopeKey)
        }
        guard let storageForInstance = storageLocator.findStorage(matchingKey: scopeKey) else {
            throw ContainerRuntimeError.scopeNotFound(scopeKey: scopeKey)
        }
        return try storageForInstance.getOrCreate(
                storageKey: storageKey,
                usingFactory: factory,
                withDependenciesFrom: scopeForDependencies)
    }
}
