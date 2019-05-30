//
//  injectable.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

public protocol Injectable{
    init()
}

public class InjectableImplementorFactory<TImplementor : Injectable> : InstanceFactory {
    func create(resolveDependenciesFrom temporaryResolver: ContextResolver) -> Any {
        return TImplementor()
    }
}
