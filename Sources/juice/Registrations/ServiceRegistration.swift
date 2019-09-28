//
// Copyright © 2019 Juice Project. All rights reserved.
//

protocol ServiceRegistration {
    func resolveServiceInstance(
            storageLocator: InstanceStorageLocator,
            scopeLocator: ResolutionScopeLocator) throws -> Any
}
