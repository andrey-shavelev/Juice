//
//  InjectableWithParameter.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

public protocol InjectableWithParameter{
    associatedtype TParameter
    
    init(_ parameter: TParameter)
}

public class InjectableImplementorFactoryWithParameter<TImplementor : InjectableWithParameter> : ImplementorFactory {
    
    func create(resolveDependenciesFrom temporaryResolver: TemporaryResolver) throws -> Any {
        return TImplementor(
            try temporaryResolver.resolve(TImplementor.TParameter.self))
    }
}
