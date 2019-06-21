//
//  ServiceRegistration.swift
//  blaze
//
//  Created by Andrey Shavelev on 25/05/2019.
//

protocol ServiceRegistration {
    func resolveServiceInstance(withDependenciesResolvedFrom scope: Scope) throws -> Any
}
