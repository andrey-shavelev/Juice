//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

protocol ServiceRegistration {
    func resolveServiceInstance(
            storageLocator: InstanceStorageLocator,
            scopeLocator: ResolutionScopeLocator) throws -> Any
}
