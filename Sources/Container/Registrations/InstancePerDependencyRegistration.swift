//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
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