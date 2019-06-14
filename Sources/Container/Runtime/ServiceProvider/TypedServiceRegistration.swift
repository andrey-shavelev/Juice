//
//  TypedServiceRegistration.swift
//  blaze
//
//  Created by Andrey Shavelev on 14/06/2019.
//

class TypedServiceRegistration: ServiceRegistration {
    
    let factory: InstanceFactory
    var propertyInjectors = [PropertyInjector]()
    var instance: Any?
    var serviceKind = InstanceScope.default
    
    init(factory: InstanceFactory) {
        self.factory = factory
    }
    
    func resolveServiceInstance(withDependenciesResolvedFrom resolver: ContextResolver) throws -> Any {
        switch serviceKind {
        case .default, .container:
            return try resolveSingleInstance(resolver)
        case .dependency:
            return try resolveInstancePerDependency(resolver)
        }
    }
    
    private func resolveSingleInstance(_ resolver: ContextResolver) throws -> Any {
        if let notNullInstance = instance
        {
            return notNullInstance
        }
        
        let instance = try CreateInstance(resolver)
        self.instance = instance
        return instance
    }
    
    private func resolveInstancePerDependency(_ resolver: ContextResolver) throws -> Any {
        return try CreateInstance(resolver)
    }
    
    private func CreateInstance(_ resolver: ContextResolver) throws -> Any {
        let instance = try factory.create(resolveDependenciesFrom: resolver)
        try InjectProperties(instance, resolver)
        return instance
    }
    
    private func InjectProperties(_ instance: Any, _ resolver: ContextResolver) throws {
        for propertyInjector in propertyInjectors {
            try propertyInjector.inject(into: instance, resolveFrom: resolver)
        }
    }
}
