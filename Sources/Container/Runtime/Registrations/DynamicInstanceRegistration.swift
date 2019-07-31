//
//  TypedServiceRegistration.swift
//  blaze
//
//  Created by Andrey Shavelev on 14/06/2019.
//

class DynamicInstanceRegistration<ServiceType>: ServiceRegistration {

    let factory: InstanceFactory
    // TODO must not be var. Collect registrations abefore build, then build with constants
    var propertyInjectors = [PropertyInjector]()
    var kind = DynamicInstanceKind.default
    
    init(factory: InstanceFactory) {
        self.factory = factory
    }
    
    func resolveServiceInstance(storageLocator: InstanceStorageLocator,
                                scopeLocator: ResolutionScopeLocator) throws -> Any {
        // TODO do not use switch, create two different types of registrations in both cases
        switch kind {
        case .perScope(let key):
            guard let scopeForDependencies = scopeLocator.findScope(matchingKey: key) else {
                throw ContainerRuntimeError.scopeNotFound(scopeKey: key)
            }
            guard let storageForInstance = storageLocator.findStorage(matchingKey: key) else {
                throw ContainerRuntimeError.scopeNotFound(scopeKey: key)
            }
            return try resolveInstancePerScope(storageForInstance, scopeForDependencies)
        case .perDependency:
            guard let scopeForDependencies = scopeLocator.findScope(matchingKey: .any) else {
                throw ContainerRuntimeError.scopeNotFound(scopeKey: .any)
            }
            return try resolveInstancePerDependency(scopeForDependencies)
        case .default:
            throw ContainerRuntimeError.missingScopeDefinition(serviceType: ServiceType.self)
        }
    }
    
    private func resolveInstancePerScope(_ instanceStorage: InstanceStorage, _ scope: Scope) throws -> Any {
        // TODO delegate logic of property injection to factory
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
    
    private func resolveInstancePerDependency(_ scope: Scope) throws -> Any {
        let instance = try factory.create(withDependenciesFrom: scope)
        try InjectProperties(instance, scope)
        return instance
    }
    
    private func InjectProperties(_ instance: Any, _ scope: Scope) throws {
        for propertyInjector in propertyInjectors {
            try propertyInjector.inject(into: instance, resolveFrom: scope)
        }
    }
}
