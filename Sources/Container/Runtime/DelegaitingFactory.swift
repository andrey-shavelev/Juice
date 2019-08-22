//
//  DelegaitingFactory.swift
//  blaze
//
//  Created by Andrey Shavelev on 22/06/2019.
//

class DelegatingFactory<Type>: InstanceFactory {

    let innerFactory: (Scope) -> Type

    init(_ innerFactory: @escaping (Scope) -> Type) {
        self.innerFactory = innerFactory
    }

    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return innerFactory(scope)
    }


}
