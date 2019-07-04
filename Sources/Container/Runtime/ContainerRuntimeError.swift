//
//  ContainerError.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

public struct ContainerRuntimeError: Error {
    
    public enum ErrorType {
        case invalidRegistration(desiredType: Any.Type, actualType: Any.Type)
        case serviceNotFound(serviceType: Any.Type)
        case invalidScope
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
}

extension ContainerRuntimeError: CustomStringConvertible {
    public var description: String {
        return message
    }
}
