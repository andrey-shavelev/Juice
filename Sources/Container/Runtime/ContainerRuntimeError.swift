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
}

extension ContainerRuntimeError: CustomStringConvertible {
    public var description: String {
        return message
    }
}
