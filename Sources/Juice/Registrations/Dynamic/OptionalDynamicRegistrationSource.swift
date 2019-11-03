//
// Copyright © 2019 Juice Project. All rights reserved.
//

class OptionalDynamicRegistrationSource: DynamicRegistrationsSource {
    func FindRegistration(forType type: Any.Type) -> ServiceRegistration? {
        if let optionalProtocol = type as? OptionalProtocol.Type {
            return OptionalServiceRegistration(optionalProtocol.elementType)
        }
        return nil
    }
}

class OptionalServiceRegistration: ServiceRegistration {
    let wrappedType: Any.Type

    init(_ wrappedType: Any.Type) {
        self.wrappedType = wrappedType
    }

    func resolveServiceInstance(storageLocator: InstanceStorageLocator, scopeLocator: ResolutionScopeLocator) throws -> Any {
        return try scopeLocator.findScope(matchingKey: ScopeKey.any)!.resolveAnyOptional(wrappedType) as Any
    }
}

protocol OptionalProtocol {
    static var elementType: Any.Type { get }
}

extension Optional: OptionalProtocol {
    static var elementType: Any.Type {
        return Wrapped.self
    }
}
