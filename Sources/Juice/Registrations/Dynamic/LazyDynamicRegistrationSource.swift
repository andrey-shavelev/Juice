//
// Copyright © 2019 Juice Project. All rights reserved.
//

class LazyDynamicRegistrationSource: DynamicRegistrationsSource {
    func FindRegistration(forType type: Any.Type) -> ServiceRegistration? {
        if let lazyProtocol = type as? LazyProtocol.Type {
            return LazyServiceRegistration(lazyProtocol.self)
        }
        return nil
    }
}

class LazyServiceRegistration: ServiceRegistration {
    let lazyProtocol: LazyProtocol.Type

    init(_ lazyProtocol: LazyProtocol.Type) {
        self.lazyProtocol = lazyProtocol
    }

    func resolveServiceInstance(storageLocator: InstanceStorageLocator, scopeLocator: ResolutionScopeLocator) throws -> Any {
        guard let scope = scopeLocator.findScope(matchingKey: ScopeKey.any) else {
            throw ContainerError.invalidScope
        }
        
        return try lazyProtocol.createInstance(scope.resolve(CurrentScope.self))
    }
}
