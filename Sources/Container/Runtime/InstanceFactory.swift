//
//  ImplementorFactory.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

internal protocol InstanceFactory {
    func create(resolveDependenciesFrom temporaryResolver: ContextResolver) throws -> Any
}
