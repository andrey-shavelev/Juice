//
//  InstanceStorage.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

protocol InstanceStorage {

    func getOrCreate<Instance>(instanceOfType type: Instance.Type,
                               usingFactory factory: InstanceFactory,
                               withDependenciesFrom scope: Scope) throws -> Any

}