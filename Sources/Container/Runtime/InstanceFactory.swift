//
//  ImplementorFactory.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

protocol InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any
}
