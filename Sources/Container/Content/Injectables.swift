//
//  injectable.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

public protocol Injectable{
    init()
}

public class InjectableFactory<Type : Injectable> : InstanceFactory {
    func create(resolveDependenciesFrom contextResolver: ContextResolver) -> Any {
        return Type()
    }
}

public protocol InjectableWithParameter{
    associatedtype ParameterType
    
    init(_ parameter: ParameterType)
}

public class InjectableFactoryWithParameter<Type : InjectableWithParameter> : InstanceFactory {
    
    func create(resolveDependenciesFrom contextResolver: ContextResolver) throws -> Any {
        return Type(
            try contextResolver.resolve(Type.ParameterType.self))
    }
}

public protocol InjectableWithTwoParameters{
    associatedtype FirstParameterType
    associatedtype SecondParameterType

    init(_ firstParameter: FirstParameterType, _ secondParameter: SecondParameterType)
}

public class InjectableFactoryWithTwoParameters<Type : InjectableWithTwoParameters> : InstanceFactory {
    
    func create(resolveDependenciesFrom contextResolver: ContextResolver) throws -> Any {
        return Type(
            try contextResolver.resolve(Type.FirstParameterType.self),
            try contextResolver.resolve(Type.SecondParameterType.self)
        )
    }
}
