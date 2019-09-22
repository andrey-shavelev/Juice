//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
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
