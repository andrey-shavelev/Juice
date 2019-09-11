//
//  Scope.swift
//  blaze
//
//  Created by Andrey Shavelev on 19/06/2019.
//

public protocol Scope {
    var isValid: Bool { get }

    func resolveAnyOptional(_ serviceType: Any.Type, withParameters parameters: [Parameter]?) throws -> Any?
}

public extension Scope {
    func resolve<Service>(_ serviceType: Service.Type) throws -> Service {
        return try castOrThrow(try resolveAny(serviceType), to: serviceType)
    }

    func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: [Parameter]) throws -> Service {
        return try castOrThrow(try resolveAny(serviceType, withParameters: parameters), to: serviceType)
    }

    func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: Parameter...) throws -> Service {
        return try resolve(serviceType, withParameters: parameters)
    }

    func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: Any...) throws -> Service {
        return try resolve(serviceType, withParameters: convertParameters(parameters))
    }

    func resolveOptional<Service>(_ serviceType: Service.Type) throws -> Service? {
        return try castOrThrowOptional(try resolveAnyOptional(serviceType), to: serviceType)
    }

    func resolveOptional<Service>(_ serviceType: Service.Type, withParameters parameters: [Parameter]) throws -> Service? {
        return try castOrThrowOptional(try resolveAnyOptional(serviceType, withParameters: parameters), to: serviceType)
    }

    func resolveOptional<Service>(_ serviceType: Service.Type, withParameters parameters: Parameter...) throws -> Service? {
        return try resolveOptional(serviceType, withParameters: parameters)
    }

    func resolveOptional<Service>(_ serviceType: Service.Type, withParameters parameters: Any...) throws -> Service? {
        return try resolveOptional(serviceType, withParameters: convertParameters(parameters))
    }

    func resolveAny(_ serviceType: Any.Type) throws -> Any {
        return try internalResolveAny(serviceType, withParameters: nil)
    }

    func resolveAny(_ serviceType: Any.Type, withParameters parameters: [Parameter]) throws -> Any {
        return try internalResolveAny(serviceType, withParameters: parameters)
    }

    func resolveAny(_ serviceType: Any.Type, withParameters parameters: Parameter...) throws -> Any {
        return try resolveAny(serviceType, withParameters: parameters)
    }

    func resolveAny(_ serviceType: Any.Type, withParameters parameters: Any...) throws -> Any {
        return try resolveAny(serviceType, withParameters: convertParameters(parameters))
    }

    func resolveAnyOptional(_ serviceType: Any.Type) throws -> Any? {
        return try resolveAnyOptional(serviceType, withParameters: nil)
    }

    private func internalResolveAny(_ serviceType: Any.Type,
                            withParameters parameters: [Parameter]?) throws -> Any {
        guard let anyInstance = try resolveAnyOptional(serviceType, withParameters: parameters) else {
            throw ContainerRuntimeError.serviceNotFound(serviceType: serviceType)
        }
        return anyInstance
    }

    private func castOrThrowOptional<Service>(_ anyInstance: Any?, to serviceType: Service.Type) throws -> Service? {
        guard let anyInstance = anyInstance else {
            return nil
        }
        return try castOrThrow(anyInstance, to: serviceType)
    }

    private func castOrThrow<Service>(_ anyInstance: Any, to serviceType: Service.Type) throws -> Service {
        guard let typedInstance = anyInstance as? Service else {
            throw ContainerRuntimeError.invalidRegistration(desiredType: Service.self,
                    actualType: type(of: anyInstance))
        }
        return typedInstance
    }

    private func convertParameters(_ parameters: [Any]) -> [Parameter] {
        return parameters.map {Parameter($0, as: type(of: $0))}
    }
}
