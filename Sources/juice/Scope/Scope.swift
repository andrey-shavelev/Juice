//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

/// A scope used to resolve services.
///
/// It could be a container itself or wrapper-type that might hold additional parameters.
/// User code should avoid holding a reference to its scope, unless absolutely needed.
///
/// - Attention: If a component keeps a strong reference to its `Scope`,
/// and uses it to resolve dependencies at a later time,
/// it needs to check `isValid` property to ensure that `Scope` is still valid.
///
public protocol Scope {
    /// Shows if scope is still valid and could be used.
    ///
    var isValid: Bool { get }

    func resolveAnyOptional(_ serviceType: Any.Type, withParameters parameters: [ParameterProtocol]?) throws -> Any?
}

public extension Scope {
    /// Resolves a component that provides `serviceType`.
    ///
    /// - Parameter serviceType: The type of required service.
    /// - Throws: `ContainerRuntimeError` when dependencies are missing
    /// or there is any other error in registrations.
    ///
    func resolve<Service>(_ serviceType: Service.Type) throws -> Service {
        return try castOrThrow(try resolveAny(serviceType), to: serviceType)
    }

    /// Resolves a component that provides `serviceType`. Uses `parameters` when creating
    /// a new instance.
    ///
    /// You can use this method when you need to specify custom parameters for `init`
    /// method of the component as well as for the property injection.
    /// Parameters are matched by the type specified and always override
    /// all services registered in container.
    ///
    /// - Parameter serviceType: The type of required service.
    /// - Parameter parameters: The array of parameters that are used to create
    /// a new instance of component.
    ///
    /// - Attention: Parameters will be ignored for single-instance component if the instance
    /// has been already created.
    /// - Throws: `ContainerRuntimeError` when dependencies are missing
    /// or there is any other error in registrations.
    ///
    func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: [ParameterProtocol]) throws -> Service {
        return try castOrThrow(try resolveAny(serviceType, withParameters: parameters), to: serviceType)
    }
    
    /// Resolves a component that provides `serviceType`. Uses `parameters` when creating
    /// a new instance.
    ///
    /// You can use this method when you need to specify custom parameters for `init`
    /// method of the component as well as for the property injection.
    /// Parameters are matched by the type specified and always override
    /// all services registered in container.
    ///
    /// - Parameter serviceType: The type of required service.
    /// - Parameter parameters: The array of parameters that are used to create
    /// a new instance of component.
    ///
    /// - Attention: Parameters will be ignored for single-instance component if the instance
    /// has been already created.
    /// - Throws: `ContainerRuntimeError` when dependencies are missing
    /// or there is any other error in registrations.
    ///
    func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: ParameterProtocol...) throws -> Service {
        return try resolve(serviceType, withParameters: parameters)
    }

    /// Resolves a component that provides `serviceType`. Uses `parameters` when creating
    /// a new instance.
    ///
    /// You can use this method when you need to specify custom parameters for `init`
    /// method of the component as well as for the property injection.
    /// Parameters are matched by the type specified and always override
    /// all services registered in container.
    ///
    /// - Parameter serviceType: The type of required service.
    /// - Parameter parameters: The array of parameters that are used to create
    /// a new instance of component.
    ///
    /// - Attention: Parameters will be ignored for single-instance component if the instance
    /// has been already created.
    /// - Throws: `ContainerRuntimeError` when dependencies are missing
    /// or there is any other error in registrations.
    ///
    func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: Any...) throws -> Service {
        return try resolve(serviceType, withParameters: convertParameters(parameters))
    }

    /// Resolves an optional component that provides `serviceType`.
    ///
    /// - Parameter serviceType: The type of required service.
    /// - Returns: The instance of component if registered; `nil` otherwise.
    /// - Throws: `ContainerRuntimeError` when dependencies are missing
    /// or there is any other error in registrations.
    ///
    func resolveOptional<Service>(_ serviceType: Service.Type) throws -> Service? {
        return try castOrThrowOptional(try resolveAnyOptional(serviceType), to: serviceType)
    }

    /// Resolves an optional component that provides `serviceType`.
    /// Uses `parameters` when creating a new instance.
    ///
    /// You can use this method when you need to specify custom parameters for `init`
    /// method of the component as well as for the property injection.
    /// Parameters are matched by the type specified and always override
    /// all services registered in container.
    ///
    /// - Parameter serviceType: The type of required service.
    /// - Parameter parameters: The array of parameters that are used to create
    /// a new instance of component.
    ///
    /// - Attention: Parameters will be ignored for single-instance component if the instance
    /// has been already created.
    /// - Returns: The instance of component if registered; `nil` otherwise.
    /// - Throws: `ContainerRuntimeError` when dependencies are missing
    /// or there is any other error in registrations.
    ///
    func resolveOptional<Service>(_ serviceType: Service.Type, withParameters parameters: [ParameterProtocol]) throws -> Service? {
        return try castOrThrowOptional(try resolveAnyOptional(serviceType, withParameters: parameters), to: serviceType)
    }
    
    /// Resolves an optional component that provides `serviceType`.
    /// Uses `parameters` when creating a new instance.
    ///
    /// You can use this method when you need to specify custom parameters for `init`
    /// method of the component as well as for the property injection.
    /// Parameters are matched by the type specified and always override
    /// all services registered in container.
    ///
    /// - Parameter serviceType: The type of required service.
    /// - Parameter parameters: The array of parameters that are used to create
    /// a new instance of component.
    ///
    /// - Attention: Parameters will be ignored for single-instance component if the instance
    /// has been already created.
    /// - Returns: The instance of component if registered; `nil` otherwise.
    /// - Throws: `ContainerRuntimeError` when dependencies are missing
    /// or there is any other error in registrations.
    ///
    func resolveOptional<Service>(_ serviceType: Service.Type, withParameters parameters: ParameterProtocol...) throws -> Service? {
        return try resolveOptional(serviceType, withParameters: parameters)
    }

    /// Resolves an optional component that provides `serviceType`.
    /// Uses `parameters` when creating a new instance.
    ///
    /// You can use this method when you need to specify custom parameters for `init`
    /// method of the component as well as for the property injection.
    /// Parameters are matched by the type specified and always override
    /// all services registered in container.
    ///
    /// - Parameter serviceType: The type of required service.
    /// - Parameter parameters: The array of parameters that are used to create
    /// a new instance of component.
    ///
    /// - Attention: Parameters will be ignored for single-instance component if the instance
    /// has been already created.
    /// - Returns: The instance of component if registered; `nil` otherwise.
    /// - Throws: `ContainerRuntimeError` when dependencies are missing
    /// or there is any other error in registrations.
    ///
    func resolveOptional<Service>(_ serviceType: Service.Type, withParameters parameters: Any...) throws -> Service? {
        return try resolveOptional(serviceType, withParameters: convertParameters(parameters))
    }

    func resolveAny(_ serviceType: Any.Type) throws -> Any {
        return try internalResolveAny(serviceType, withParameters: nil)
    }

    func resolveAny(_ serviceType: Any.Type, withParameters parameters: [ParameterProtocol]) throws -> Any {
        return try internalResolveAny(serviceType, withParameters: parameters)
    }

    func resolveAny(_ serviceType: Any.Type, withParameters parameters: ParameterProtocol...) throws -> Any {
        return try resolveAny(serviceType, withParameters: parameters)
    }

    func resolveAny(_ serviceType: Any.Type, withParameters parameters: Any...) throws -> Any {
        return try resolveAny(serviceType, withParameters: convertParameters(parameters))
    }

    func resolveAnyOptional(_ serviceType: Any.Type) throws -> Any? {
        return try resolveAnyOptional(serviceType, withParameters: nil)
    }

    private func internalResolveAny(_ serviceType: Any.Type,
                            withParameters parameters: [ParameterProtocol]?) throws -> Any {
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

    private func convertParameters(_ parameters: [Any]) -> [ParameterProtocol] {
        return parameters.map {AnyParameter($0, type(of: $0))}
    }
}
