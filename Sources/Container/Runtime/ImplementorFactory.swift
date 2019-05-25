//
//  ImplementorFactory.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

internal protocol ImplementorFactory {
    func create(resolveDependenciesFrom temporaryResolver: TemporaryResolver) throws -> Any
}
