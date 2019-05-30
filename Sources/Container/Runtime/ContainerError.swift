//
//  ContainerError.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

public struct ContainerError: Error, CustomStringConvertible {
    
    public enum ErrorType {
        case invalidRegistration(desiredType: Any.Type, actualType: Any.Type)
        case serviceNotFound(serviceType: Any.Type)
    }
    
    let message: String
    let errorType: ErrorType
    public var description: String {
        return message
    }
    
    init(message: String, errorType: ErrorType) {
        self.message = message
        self.errorType = errorType
    }
    
    static func invalidRegistration(desiredType: Any.Type, actualType: Any.Type) -> ContainerError {
        return ContainerError(message: "Invalid registration, type\(actualType) could not be casted to \(desiredType)", errorType: .invalidRegistration(desiredType: desiredType, actualType: actualType))
    }
    
    static func serviceNotFound(serviceType: Any.Type) -> ContainerError {
        return ContainerError(message: "Missing registration for: \(serviceType)",
            errorType: .serviceNotFound(serviceType: serviceType))
    }
}
