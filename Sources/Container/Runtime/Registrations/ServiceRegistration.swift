//
//  ServiceRegistration.swift
//  blaze
//
//  Created by Andrey Shavelev on 25/05/2019.
//

protocol ServiceRegistration {
    func resolveServiceInstance(withDependenciesResolvedFrom resolver: ContextResolver) throws -> Any
}
