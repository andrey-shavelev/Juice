//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

public class Factory<Type>: CustomInjectable {
    let scope: Scope

    public required init(inScope scope: Scope) throws {
        self.scope = try scope.resolve(Scope.self)
    }

    func create<ParameterType>(_ parameter: ParameterType) throws -> Type {
        return try scope.resolve(Type.self)
    }
}
