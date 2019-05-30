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

public class InjectableImplementorFactoryWithParameter<TImplementor : InjectableWithParameter> : InstanceFactory {
    
    func create(resolveDependenciesFrom temporaryResolver: ContextResolver) throws -> Any {
        return TImplementor(
            try temporaryResolver.resolve(TImplementor.TParameter.self))
    }
}
