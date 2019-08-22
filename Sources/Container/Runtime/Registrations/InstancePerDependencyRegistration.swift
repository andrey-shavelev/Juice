//
//  TypedServiceRegistration.swift
//  blaze
//
//  Created by Andrey Shavelev on 14/06/2019.
//

class InstancePerDependencyRegistration<ServiceType>: ServiceRegistration {
    let factory: InstanceFactory
    // TODO put injection in factory wrapper
    let propertyInjectors: [PropertyInjector]

    init(factory: InstanceFactory, propertyInjectors: [PropertyInjector]) {
        self.factory = factory
        self.propertyInjectors = propertyInjectors
    }

    func resolveServiceInstance(storageLocator: InstanceStorageLocator, scopeLocator: ResolutionScopeLocator) throws -> Any {
        guard let scopeForDependencies = scopeLocator.findScope(matchingKey: .any) else {
            throw ContainerRuntimeError.scopeNotFound(scopeKey: .any)
        }
        return try resolveInstancePerDependency(scopeForDependencies)
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
