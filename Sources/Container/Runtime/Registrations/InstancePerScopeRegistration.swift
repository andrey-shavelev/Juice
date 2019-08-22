//
// Created by Andrey Shavelev on 2019-08-19.
//

class InstancePerScopeRegistration<ServiceType>: ServiceRegistration {

    let factory: InstanceFactory
    // TODO put injection in factory wrapper
    let propertyInjectors: [PropertyInjector]
    let scopeKey: ScopeKey

    init(factory: InstanceFactory, scopeKey: ScopeKey, propertyInjectors: [PropertyInjector]) {
        self.factory = factory
        self.scopeKey = scopeKey
        self.propertyInjectors = propertyInjectors
    }

    func resolveServiceInstance(storageLocator: InstanceStorageLocator,
                                scopeLocator: ResolutionScopeLocator) throws -> Any {
        guard let scopeForDependencies = scopeLocator.findScope(matchingKey: scopeKey) else {
            throw ContainerRuntimeError.scopeNotFound(scopeKey: scopeKey)
        }
        guard let storageForInstance = storageLocator.findStorage(matchingKey: scopeKey) else {
            throw ContainerRuntimeError.scopeNotFound(scopeKey: scopeKey)
        }
        return try resolveInstancePerScope(storageForInstance, scopeForDependencies)
    }

    private func resolveInstancePerScope(_ instanceStorage: InstanceStorage, _ scope: Scope) throws -> Any {
        switch try instanceStorage.getOrCreate(
                instanceOfType: ServiceType.self,
                usingFactory: factory,
                withDependenciesFrom: scope) {
        case (InstanceFlag.new, let newInstance):
            try InjectProperties(newInstance, scope)
            return newInstance
        case (InstanceFlag.existing, let existingInstance):
            return existingInstance
        }
    }

    private func InjectProperties(_ instance: Any, _ scope: Scope) throws {
        for propertyInjector in propertyInjectors {
            try propertyInjector.inject(into: instance, resolveFrom: scope)
        }
    }
}