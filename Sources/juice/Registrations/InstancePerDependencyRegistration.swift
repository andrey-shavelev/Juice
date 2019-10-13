//
// Copyright © 2019 Juice Project. All rights reserved.
//

class InstancePerDependencyRegistration<ServiceType>: ServiceRegistration {
    let factory: InstanceFactory

    init(factory: InstanceFactory) {
        self.factory = factory
    }

    func resolveServiceInstance(storageLocator: InstanceStorageLocator, scopeLocator: ResolutionScopeLocator) throws -> Any {
        guard let scopeForDependencies = scopeLocator.findScope(matchingKey: .any) else {
            throw ContainerError.scopeNotFound(scopeKey: .any)
        }
        
        ScopeStack.push(scopeForDependencies)
        defer {
            ScopeStack.pop()
        }
        
        return try factory.create(withDependenciesFrom: scopeForDependencies)
    }
}
