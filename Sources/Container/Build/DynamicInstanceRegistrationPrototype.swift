//
// Created by Andrey Shavelev on 2019-08-04.
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
            throw ContainerRuntimeError.missingScopeDefinition(serviceType: Type.self)
        }

        let actualFactory = propertyInjectors.count == 0
                ? factory
                : PropertyInjectingFactoryWrapper(innerFactory: factory, propertyInjectors: propertyInjectors)

        switch (kind) {
        case .perDependency:
            return InstancePerDependencyRegistration<Type>(factory: actualFactory)
        case .perScope(let key):
            return InstancePerScopeRegistration<Type>(
                    factory: actualFactory,
                    scopeKey: key,
                    storageKey: storageKey)
        }
    }
}
