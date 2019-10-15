//
// Copyright © 2019 Juice Project. All rights reserved.
//

// MARK: Protocols

public protocol Injectable {
    init() throws
}

public protocol InjectableWithParameter {
    associatedtype ParameterType

    init(_ parameter: ParameterType) throws
}

public protocol InjectableWithTwoParameters {
    associatedtype FirstParameterType
    associatedtype SecondParameterType

    init(_ firstParameter: FirstParameterType, _ secondParameter: SecondParameterType) throws
}

public protocol InjectableWithThreeParameters {
    associatedtype FirstParameterType
    associatedtype SecondParameterType
    associatedtype ThirdParameterType

    init(_ firstParameter: FirstParameterType,
         _ secondParameter: SecondParameterType,
         _ thirdParameter: ThirdParameterType) throws
}
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


// MARK: Aliases

public typealias InjectableWith1Parameter = InjectableWithParameter
public typealias InjectableWithOneParameter = InjectableWithParameter
public typealias InjectableWith2Parameters = InjectableWithTwoParameters
public typealias InjectableWith3Parameters = InjectableWithThreeParameters
public typealias InjectableWith4Parameters = InjectableWithFourParameters
public typealias InjectableWith5Parameters = InjectableWithFiveParameters


//MARK: Factories

class InjectableFactory<Type: Injectable>: InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return try Type()
    }
}

class InjectableFactoryWithParameter<Type: InjectableWithParameter>: InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return try Type(try scope.resolve(Type.ParameterType.self))
    }
}

class InjectableFactoryWithTwoParameters<Type: InjectableWithTwoParameters>: InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return try Type(
                try scope.resolve(Type.FirstParameterType.self),
                try scope.resolve(Type.SecondParameterType.self)
        )
    }
}

class InjectableFactoryWithThreeParameters<Type: InjectableWithThreeParameters>: InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return try Type(try scope.resolve(Type.FirstParameterType.self),
                try scope.resolve(Type.SecondParameterType.self),
                try scope.resolve(Type.ThirdParameterType.self))
    }
}

class InjectableFactoryWithFourParameters<Type: InjectableWithFourParameters>: InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return try Type(try scope.resolve(Type.FirstParameterType.self),
                try scope.resolve(Type.SecondParameterType.self),
                try scope.resolve(Type.ThirdParameterType.self),
                try scope.resolve(Type.FourthParameterType.self))
    }
}

class InjectableFactoryWithFiveParameters<Type: InjectableWithFiveParameters>: InstanceFactory {
    func create(withDependenciesFrom scope: Scope) throws -> Any {
        return try Type(try scope.resolve(Type.FirstParameterType.self),
                try scope.resolve(Type.SecondParameterType.self),
                try scope.resolve(Type.ThirdParameterType.self),
                try scope.resolve(Type.FourthParameterType.self),
                try scope.resolve(Type.FifthParameterType.self))
    }
}
