//
//  ServiceRegistration.swift
//  blaze
//
//  Created by Andrey Shavelev on 25/05/2019.
//

protocol ServiceRegistration {
    func resolveServiceInstance(
            storageLocator: InstanceStorageLocator,
            scopeLocator: ResolutionScopeLocator) throws -> Any
}
