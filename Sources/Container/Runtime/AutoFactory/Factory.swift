//
//  AutoFactory.swift
//  blaze
//
//  Created by Andrey Shavelev on 18/06/2019.
//

public class Factory<Type> : CustomInjectable {    
    let scope: Scope
    
    public required init(receiveDependenciesFrom contextResolver: ContextResolver) throws {
        self.scope = try contextResolver.resolve(Scope.self)
    }
    
    func create<ParameterType>(_ parameter: ParameterType) throws -> Type {
        return try scope.resolve(Type.self)
    }
}
