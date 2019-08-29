//
//  TypedServiceRegistration.swift
//  blaze
//
//  Created by Andrey Shavelev on 14/06/2019.
//

class InstancePerDependencyRegistration<ServiceType>: ServiceRegistration {
    let factory: InstanceFactory

    init(factory: InstanceFactory) {
        self.factory = factory
    }

    func resolveServiceInstance(storageLocator: InstanceStorageLocator, scopeLocator: ResolutionScopeLocator) throws -> Any {
        guard let scopeForDependencies = scopeLocator.findScope(matchingKey: .any) else {
            throw ContainerRuntimeError.scopeNotFound(scopeKey: .any)
        }
        return try factory.create(withDependenciesFrom: scopeForDependencies)
    }
}
