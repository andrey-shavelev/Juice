//
// Copyright © 2019 Juice Project. All rights reserved.
//

public protocol Injectable {
    init() throws
}

public class InjectableFactory<Type: Injectable>: InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return try Type()
    }
}

public protocol InjectableWithParameter {
    associatedtype ParameterType

    init(_ parameter: ParameterType) throws
}

public class InjectableFactoryWithParameter<Type: InjectableWithParameter>: InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return try Type(try scope.resolve(Type.ParameterType.self))
    }
}

public protocol InjectableWithTwoParameters {
    associatedtype FirstParameterType
    associatedtype SecondParameterType

    init(_ firstParameter: FirstParameterType, _ secondParameter: SecondParameterType) throws
}
public typealias InjectableWith2Parameters = InjectableWithTwoParameters

public class InjectableFactoryWithTwoParameters<Type: InjectableWithTwoParameters>: InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return try Type(
                try scope.resolve(Type.FirstParameterType.self),
                try scope.resolve(Type.SecondParameterType.self)
        )
    }
}

public protocol InjectableWithThreeParameters {
    associatedtype FirstParameterType
    associatedtype SecondParameterType
    associatedtype ThirdParameterType

    init(_ firstParameter: FirstParameterType,
         _ secondParameter: SecondParameterType,
         _ thirdParameter: ThirdParameterType) throws
}
public typealias InjectableWith3Parameters = InjectableWithThreeParameters

public class InjectableFactoryWithThreeParameters<Type: InjectableWithThreeParameters>: InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return try Type(try scope.resolve(Type.FirstParameterType.self),
                try scope.resolve(Type.SecondParameterType.self),
                try scope.resolve(Type.ThirdParameterType.self))
    }
}
public typealias InjectableWith4Parameters = InjectableWithFourParameters

public protocol InjectableWithFourParameters {
    associatedtype FirstParameterType
    associatedtype SecondParameterType
    associatedtype ThirdParameterType
    associatedtype FourthParameterType

    init(_ firstParameter: FirstParameterType,
         _ secondParameter: SecondParameterType,
         _ thirdParameter: ThirdParameterType,
         _ fourthParameter: FourthParameterType) throws
}

public class InjectableFactoryWithFourParameters<Type: InjectableWithFourParameters>: InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return try Type(try scope.resolve(Type.FirstParameterType.self),
                try scope.resolve(Type.SecondParameterType.self),
                try scope.resolve(Type.ThirdParameterType.self),
                try scope.resolve(Type.FourthParameterType.self))
    }
}

public typealias InjectableWith5Parameters = InjectableWithFiveParameters

public protocol InjectableWithFiveParameters {
    associatedtype FirstParameterType
    associatedtype SecondParameterType
    associatedtype ThirdParameterType
    associatedtype FourthParameterType
    associatedtype FifthParameterType

    init(_ firstParameter: FirstParameterType,
         _ secondParameter: SecondParameterType,
         _ thirdParameter: ThirdParameterType,
         _ fourthParameter: FourthParameterType,
         _ fifthParameter: FifthParameterType) throws
}

public class InjectableFactoryWithFiveParameters<Type: InjectableWithFiveParameters>: InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return try Type(try scope.resolve(Type.FirstParameterType.self),
                try scope.resolve(Type.SecondParameterType.self),
                try scope.resolve(Type.ThirdParameterType.self),
                try scope.resolve(Type.FourthParameterType.self),
                try scope.resolve(Type.FifthParameterType.self))
    }
}
