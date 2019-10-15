//
// Copyright © 2019 Juice Project. All rights reserved.
//

class UnownedExternalInstanceRegistration<Type: AnyObject>: ServiceRegistration {
    unowned let instance: Type

    init(instance: Type) {
        self.instance = instance
    }

    func resolveServiceInstance(storageLocator: InstanceStorageLocator, scopeLocator: ResolutionScopeLocator) throws -> Any {
        return instance
    }
}

class OwnedExternalInstanceRegistration<Type>: ServiceRegistration {
    let instance: Type

    init(instance: Type) {
        self.instance = instance
    }

    func resolveServiceInstance(storageLocator: InstanceStorageLocator, scopeLocator: ResolutionScopeLocator) throws -> Any {
        return instance
    }
}
