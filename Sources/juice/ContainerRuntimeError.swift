//
// Copyright © 2019 Juice Project. All rights reserved.
//

public struct ContainerRuntimeError: Error {

    public enum ErrorType {
        case invalidRegistration(desiredType: Any.Type, actualType: Any.Type)
        case serviceNotFound(serviceType: Any.Type)
        case invalidScope
        case missingScopeDefinition(componentType: Any.Type)
        case scopeNotFound(scopeKey: ScopeKey)
        case missingOwnershipDefinition(componentType: Any.Type)
        case dependencyCycle(componentType: Any.Type)
    }

    public let message: String
    public let errorType: ErrorType

    internal init(message: String, errorType: ErrorType) {
        self.message = message
        self.errorType = errorType
    }

}

extension ContainerRuntimeError {
    static func invalidRegistration(desiredType: Any.Type, actualType: Any.Type) -> ContainerRuntimeError {
        return ContainerRuntimeError(message: "Invalid registration, type\(actualType) could not be casted to \(desiredType)", errorType: .invalidRegistration(desiredType: desiredType, actualType: actualType))
    }

    static func serviceNotFound(serviceType: Any.Type) -> ContainerRuntimeError {
        return ContainerRuntimeError(message: "Missing registration for: \(serviceType)",
                errorType: .serviceNotFound(serviceType: serviceType))
    }

    static func invalidScope() -> ContainerRuntimeError {
        return ContainerRuntimeError(message: "Parent scope was dealocated and its child scope could not be used to resolve dependencies. This error may indicate that a class, that keeps a reference to a scope, has a wrong lifecycle and lives longer than its scope. In case if it is intended, please check if scope is still valid using isValid property.",
                errorType: .invalidScope)
    }

    static func scopeNotFound(scopeKey: ScopeKey) -> ContainerRuntimeError {
        return ContainerRuntimeError(message: "Could not find scope for a key:\(scopeKey).",
                errorType: .scopeNotFound(scopeKey: scopeKey))
    }

    static func missingScopeDefinition(componentType: Any.Type) -> ContainerRuntimeError {
        // Check naming service vs component
        return ContainerRuntimeError(
                message: "Dynamic instance scope must be defined for \(componentType). Use .singleInstance() or .instancePerDependency() or other option.", 
                errorType: .missingScopeDefinition(componentType: componentType))
    }

    static func missingOwnershipDefinition(componentType: Any.Type) -> ContainerRuntimeError {
        return ContainerRuntimeError(message: "Ownership must be defined for \(componentType). Use .ownedByContainer() or .ownedExternally().", 
                errorType: .missingOwnershipDefinition(componentType: componentType))
    }
    
    static func dependencyCycle(componentType: Any.Type) -> ContainerRuntimeError {
        return ContainerRuntimeError(message: "Dependency cycle found while resolving: \(componentType)", errorType: .dependencyCycle(componentType: componentType))
    }
}

extension ContainerRuntimeError: CustomStringConvertible {
    public var description: String {
        return message
    }
}
