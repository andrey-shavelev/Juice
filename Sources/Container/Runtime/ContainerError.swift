//
//  ContainerError.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

public enum ContainerError: Error {
    case serviceNotFound(serviceType: Any.Type)
    case invalidType(expectedType: Any.Type, actualType: Any.Type)
}
