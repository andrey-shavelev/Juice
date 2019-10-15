//
// Copyright © 2019 Juice Project. All rights reserved.
//

class DelegatingFactory<Type>: InstanceFactory {

    let innerFactory: (Scope) throws -> Type

    init(_ innerFactory: @escaping (Scope) throws -> Type) {
        self.innerFactory = innerFactory
    }

    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return try innerFactory(scope)
    }
}
