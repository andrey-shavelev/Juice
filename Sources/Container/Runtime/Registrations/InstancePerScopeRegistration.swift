//
// Created by Andrey Shavelev on 2019-08-19.
//

class InstancePerScopeRegistration<ServiceType>: ServiceRegistration {
    let factory: InstanceFactory
    let scopeKey: ScopeKey

    init(factory: InstanceFactory, scopeKey: ScopeKey) {
        self.factory = factory
        self.scopeKey = scopeKey
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
                instanceOfType: ServiceType.self,
                usingFactory: factory,
                withDependenciesFrom: scopeForDependencies)
    }
}