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

public protocol InjectableWithThreeParameters{
    associatedtype FirstParameterType
    associatedtype SecondParameterType
    associatedtype ThirdParameterType
    
    init(_ firstParameter: FirstParameterType,
         _ secondParameter: SecondParameterType,
         _ thirdParameter: ThirdParameterType)
}

public class InjectableFactoryWithThreeParameters<Type : InjectableWithThreeParameters> : InstanceFactory {
    func create(resolveDependenciesFrom contextResolver: ContextResolver) throws -> Any {
        return Type(try contextResolver.resolve(Type.FirstParameterType.self),
                    try contextResolver.resolve(Type.SecondParameterType.self),
                    try contextResolver.resolve(Type.ThirdParameterType.self))
    }
}

public protocol InjectableWithFourParameters{
    associatedtype FirstParameterType
    associatedtype SecondParameterType
    associatedtype ThirdParameterType
    associatedtype FourthParameterType
    
    init(_ firstParameter: FirstParameterType,
         _ secondParameter: SecondParameterType,
         _ thirdParameter: ThirdParameterType,
         _ fourthParameter: FourthParameterType)
}

public class InjectableFactoryWithFourParameters<Type : InjectableWithFourParameters> : InstanceFactory {
    func create(resolveDependenciesFrom contextResolver: ContextResolver) throws -> Any {
        return Type(try contextResolver.resolve(Type.FirstParameterType.self),
                    try contextResolver.resolve(Type.SecondParameterType.self),
                    try contextResolver.resolve(Type.ThirdParameterType.self),
                    try contextResolver.resolve(Type.FourthParameterType.self))
    }
}

public protocol InjectableWithFiveParameters{
    associatedtype FirstParameterType
    associatedtype SecondParameterType
    associatedtype ThirdParameterType
    associatedtype FourthParameterType
    associatedtype FifthParameterType
    
    init(_ firstParameter: FirstParameterType,
         _ secondParameter: SecondParameterType,
         _ thirdParameter: ThirdParameterType,
         _ fourthParameter: FourthParameterType,
         _ fifthParameter: FifthParameterType)
}

public class InjectableFactoryWithFiveParameters<Type : InjectableWithFiveParameters> : InstanceFactory {
    func create(resolveDependenciesFrom contextResolver: ContextResolver) throws -> Any {
        return Type(try contextResolver.resolve(Type.FirstParameterType.self),
                    try contextResolver.resolve(Type.SecondParameterType.self),
                    try contextResolver.resolve(Type.ThirdParameterType.self),
                    try contextResolver.resolve(Type.FourthParameterType.self),
                    try contextResolver.resolve(Type.FifthParameterType.self))
    }
}

public protocol CustomInjectable {    
    init(receiveDependenciesFrom contextResolver: ContextResolver) throws
}

public class CustomInjectableFactory<Type : CustomInjectable> : InstanceFactory {
    func create(resolveDependenciesFrom contextResolver: ContextResolver) throws -> Any {
        return try Type(receiveDependenciesFrom: contextResolver)
    }
}
