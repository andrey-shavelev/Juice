//
//  TypedServiceRegistration.swift
//  blaze
//
//  Created by Andrey Shavelev on 14/06/2019.
//

class DynamicInstanceRegistration: ServiceRegistration {
    
    let factory: InstanceFactory
    var propertyInjectors = [PropertyInjector]()
    var instance: Any?
    var serviceKind = DynamicInstanceScope.default
    
    init(factory: InstanceFactory) {
        self.factory = factory
    }
    
    func resolveServiceInstance(withDependenciesResolvedFrom scope: Scope) throws -> Any {
        switch serviceKind {
        case .default, .container:
            return try resolveSingleInstance(scope)
        case .dependency:
            return try resolveInstancePerDependency(scope)
        }
    }
    
    private func resolveSingleInstance(_ scope: Scope) throws -> Any {
        if let notNullInstance = instance
        {
            return notNullInstance
        }
        
        let instance = try CreateInstance(scope)
        self.instance = instance
        return instance
    }
    
    private func resolveInstancePerDependency(_ scope: Scope) throws -> Any {
        return try CreateInstance(scope)
    }
    
    private func CreateInstance(_ scope: Scope) throws -> Any {
        let instance = try factory.create(withDependenciesResolvedFrom: scope)
        try InjectProperties(instance, scope)
        return instance
    }
    
    private func InjectProperties(_ instance: Any, _ scope: Scope) throws {
        for propertyInjector in propertyInjectors {
            try propertyInjector.inject(into: instance, resolveFrom: scope)
        }
    }
}
