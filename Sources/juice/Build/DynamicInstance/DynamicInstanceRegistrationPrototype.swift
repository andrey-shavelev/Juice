//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

class DynamicInstanceRegistrationPrototype<Type>: ServiceRegistrationPrototype {
    var factory: InstanceFactory
    var propertyInjectors: [PropertyInjector] = []
    var kind: DynamicInstanceKind?
    var services: [Any.Type] = []
    let scopeKey: ScopeKey
    let storageKey: StorageKey

    init(factory: InstanceFactory, scopeKey: ScopeKey) {
        self.factory = factory
        self.scopeKey = scopeKey
        self.storageKey = StorageKey()
    }

    func build() throws -> ServiceRegistration {
        guard let kind = kind else {
            throw ContainerError.missingLifetimeDefinition(componentType: Type.self)
        }

        switch (kind) {
        case .perDependency:
            return InstancePerDependencyRegistration<Type>(factory: buildFactory(kind))
        case .perScope(let key):
            return InstancePerScopeRegistration<Type>(
                    factory: buildFactory(kind),
                    scopeKey: key,
                    storageKey: storageKey)
        }
    }
    
    func buildFactory(_ kind: DynamicInstanceKind) -> InstanceFactory {
        var actualFactory = factory
        
        if propertyInjectors.count > 0 {
            actualFactory = PropertyInjectingFactoryWrapper(actualFactory, propertyInjectors)
        }
        
        if case DynamicInstanceKind.perScope(_) = kind {
            actualFactory = InstancePerScopeComponentFactoryWrapper(actualFactory, Type.self)
        }

        return actualFactory
    }
}
