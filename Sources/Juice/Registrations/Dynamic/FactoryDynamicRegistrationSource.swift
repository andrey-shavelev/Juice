//
// Copyright © 2019 Juice Project. All rights reserved.
//

class FactoryDynamicRegistrationSource: DynamicRegistrationsSource {
    func FindRegistration(forType type: Any.Type) -> ServiceRegistration? {
        if let factoryProtocol = type as? FactoryProtocol.Type {
            return FactoryServiceRegistration(factoryProtocol.self)
        }
        return nil
    }
}

class FactoryServiceRegistration: ServiceRegistration {
    let factoryProtocolType: FactoryProtocol.Type

    init(_ factoryProtocol: FactoryProtocol.Type) {
        self.factoryProtocolType = factoryProtocol
    }

    func resolveServiceInstance(storageLocator: InstanceStorageLocator, scopeLocator: ResolutionScopeLocator) throws -> Any {        
        guard let scope = scopeLocator.findScope(matchingKey: ScopeKey.any) else {
            throw ContainerError.invalidScope
        }
        
        return factoryProtocolType.createInstance(scope)
    }
}
