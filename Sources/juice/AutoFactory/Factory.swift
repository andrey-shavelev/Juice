//
// Copyright © 2019 Juice Project. All rights reserved.
//

public class Factory<Type>: InjectableWithParameter {
    let scope: CurrentScope

    public required init(_ scope: CurrentScope) {
        self.scope = scope
    }

    func create<ParameterType>(_ parameter: ParameterType) throws -> Type {
        return try scope.resolve(Type.self)
    }
}
