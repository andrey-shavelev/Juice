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
    func create(withDependenciesResolvedFrom scope: Scope) throws -> Any {
        return Type()
    }
}

public protocol InjectableWithParameter{
    associatedtype ParameterType
    
    init(_ parameter: ParameterType)
}

public class InjectableFactoryWithParameter<Type : InjectableWithParameter> : InstanceFactory {
    func create(withDependenciesResolvedFrom scope: Scope) throws -> Any {
        return Type(try scope.resolve(Type.ParameterType.self))
    }
}

public protocol InjectableWithTwoParameters{
    associatedtype FirstParameterType
    associatedtype SecondParameterType

    init(_ firstParameter: FirstParameterType, _ secondParameter: SecondParameterType)
}

public class InjectableFactoryWithTwoParameters<Type : InjectableWithTwoParameters> : InstanceFactory {
    func create(withDependenciesResolvedFrom scope: Scope) throws -> Any {
        return Type(
            try scope.resolve(Type.FirstParameterType.self),
            try scope.resolve(Type.SecondParameterType.self)
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
    func create(withDependenciesResolvedFrom scope: Scope) throws -> Any {
        return Type(try scope.resolve(Type.FirstParameterType.self),
                    try scope.resolve(Type.SecondParameterType.self),
                    try scope.resolve(Type.ThirdParameterType.self))
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
    func create(withDependenciesResolvedFrom scope: Scope) throws -> Any {
        return Type(try scope.resolve(Type.FirstParameterType.self),
                    try scope.resolve(Type.SecondParameterType.self),
                    try scope.resolve(Type.ThirdParameterType.self),
                    try scope.resolve(Type.FourthParameterType.self))
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
    func create(withDependenciesResolvedFrom scope: Scope) throws -> Any {
        return Type(try scope.resolve(Type.FirstParameterType.self),
                    try scope.resolve(Type.SecondParameterType.self),
                    try scope.resolve(Type.ThirdParameterType.self),
                    try scope.resolve(Type.FourthParameterType.self),
                    try scope.resolve(Type.FifthParameterType.self))
    }
}

public protocol CustomInjectable {    
    init(receiveDependenciesFrom contextResolver: Scope) throws
}

public class CustomInjectableFactory<Type : CustomInjectable> : InstanceFactory {
    func create(withDependenciesResolvedFrom scope: Scope) throws -> Any {
        return try Type(receiveDependenciesFrom: scope)
    }
}
