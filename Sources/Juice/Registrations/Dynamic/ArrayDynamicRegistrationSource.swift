//
//  File.swift
//  
//
//  Created by Andrey Shavelev on 04/05/2020.
//

class ArrayDynamicRegistrationSource: DynamicRegistrationsSource {
    func FindRegistration(forType type: Any.Type) -> ServiceRegistration? {
        if let optionalProtocol = type as? ArrayProtocol.Type {
            return ArrayServiceRegistration(optionalProtocol.elementType)
        }
        return nil
    }
}

class ArrayServiceRegistration: ServiceRegistration {
    let wrappedType: Any.Type

    init(_ wrappedType: Any.Type) {
        self.wrappedType = wrappedType
    }

    func resolveServiceInstance(storageLocator: InstanceStorageLocator, scopeLocator: ResolutionScopeLocator) throws -> Any {
        return try scopeLocator.findScope(matchingKey: ScopeKey.any)!.resolveAll(wrappedType, withArguments: nil)
    }
}

protocol ArrayProtocol {
    static var elementType: Any.Type { get }
}

extension Array: ArrayProtocol {
    static var elementType: Any.Type {
        return Element.self
    }
}
