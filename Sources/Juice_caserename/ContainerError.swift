//
// Copyright © 2019 Juice Project. All rights reserved.
//

public enum ContainerError: Error {

    case invalidRegistration(desiredType: Any.Type, actualType: Any.Type)
    case serviceNotFound(serviceType: Any.Type)
    case invalidScope
    case missingLifetimeDefinition(componentType: Any.Type)
    case scopeNotFound(scopeKey: ScopeKey)
    case missingOwnershipDefinition(componentType: Any.Type)
    case dependencyCycle(componentType: Any.Type)
}

extension ContainerError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidRegistration(let desiredType, let actualType):
            return "Invalid registration, \(actualType) could not be converted to \(desiredType)"
        case .serviceNotFound(let serviceType):
            return "Missing registration for: \(serviceType)"
        case .invalidScope:
            return "Container was deallocated and its child scope could not be used to resolve dependencies."
        case .missingLifetimeDefinition(let componentType):
            return "Lifetime must be defined for \(componentType). Use .singleInstance() or .instancePerDependency() or other option."
        case .scopeNotFound(let scopeKey):
            return "Could not find scope for a key: \(scopeKey)."
        case .missingOwnershipDefinition(let componentType):
            return "Ownership kind must be defined for \(componentType). Use .ownedByContainer() or .ownedExternally()."
        case .dependencyCycle(let componentType):
            return "Dependency cycle found while resolving: \(componentType)"
        @unknown default:
            return "Container Error: \(self)"
        }
    }
}
