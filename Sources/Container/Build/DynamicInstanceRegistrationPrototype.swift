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
    let serviceProviderType: Any.Type

    init(factory: InstanceFactory, scopeKey: ScopeKey) {
        self.factory = factory
        self.scopeKey = scopeKey
        self.serviceProviderType = Type.self
    }

    func build() throws -> ServiceRegistration {

        guard let kind = kind else {
            throw ContainerRuntimeError.missingScopeDefinition(serviceType: Type.self)
        }

        switch (kind) {
        case .perDependency:
            return InstancePerDependencyRegistration<Type>(factory: factory, propertyInjectors: propertyInjectors)
        case .perScope(let key):
            return InstancePerScopeRegistration<Type>(factory: factory, scopeKey: key, propertyInjectors: propertyInjectors)
        }
    }
}