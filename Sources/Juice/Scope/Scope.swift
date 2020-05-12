//
// Copyright © 2019 Juice Project. All rights reserved.
//

/// A scope containing a set of services.
///
/// At runtime it could be a `Container` itself or wrapper-type that might hold additional arguments.
///
public protocol Scope {
    func resolveAnyOptional(_ serviceType: Any.Type, withArguments arguments: [ArgumentProtocol]?) throws -> Any?
    
    func resolveAnyOptional<Key: Hashable>(_ serviceType: Any.Type, forKey key: Key, withArguments arguments: [ArgumentProtocol]?) throws -> Any?
    
    func resolveAll(_ serviceType: Any.Type, withArguments arguments: [ArgumentProtocol]?) throws -> [Any]
    
    func resolveAll<Key: Hashable>(_ serviceType: Any.Type, forKey key: Key, withArguments arguments: [ArgumentProtocol]?) throws -> [Any]
}

public extension Scope {
    // MARK: Resolve
    
    
    /// Resolves a `serviceType` service.
    ///
    /// - Returns: An instance of a component that provides `serviceType` service.
    /// - Parameter serviceType: The type of required service.
    /// - Throws: `ContainerError`.
    ///
    func resolve<Service>(_ serviceType: Service.Type) throws -> Service {
        try castOrThrow(try resolveAny(serviceType), to: serviceType)
    }
    
    
    func resolve<Service, Key: Hashable>(_ serviceType: Service.Type, forKey key: Key) throws -> Service {
        try castOrThrow(try resolveAny(serviceType, forKey: key), to: serviceType)
    }

    /// Resolves a `serviceType` service, using additional `arguments`.
    ///
    /// You can use this method when you need to specify custom arguments for `init()
    /// method of the component as well as for the property injection.
    /// Parameters are matched by the exact type and override
    /// services registered in the container.
    ///
    /// - Parameter serviceType: The type of resolved service.
    /// - Parameter arguments: The array of additional arguments that are used while creating
    /// a new instance of the component.
    ///
    /// - Returns: An instance of a component that provides `serviceType` service.
    /// - Attention: Parameters will be ignored for a single-instance component if its instance
    /// has been already created.
    /// - Throws: `ContainerError`.
    ///
    func resolve<Service>(_ serviceType: Service.Type, withArguments arguments: [ArgumentProtocol]) throws -> Service {
        try castOrThrow(try resolveAny(serviceType, withArguments: arguments), to: serviceType)
    }
    
    func resolve<Service, Key: Hashable>(_ serviceType: Service.Type, forKey key: Key, withArguments arguments: [ArgumentProtocol]) throws -> Service {
        try castOrThrow(try resolveAny(serviceType, forKey: key, withArguments: arguments), to: serviceType)
    }

    /// Resolves a `serviceType` service, using additional `arguments`.
    ///
    /// You can use this method when you need to specify custom arguments for `init()`
    /// method of the component as well as for the property injection.
    /// Parameters are matched by the type specified and always override
    /// all services registered in container.
    ///
    /// - Parameter serviceType: The type of resolved service.
    /// - Parameter arguments: The array of arguments that are used to create
    /// a new instance of component.
    ///
    /// - Returns: An instance of a component that provides `serviceType` service.
    /// - Attention: Parameters will be ignored for single-instance component if the instance
    /// has been already created.
    /// - Throws: `ContainerError`.
    ///
    func resolve<Service>(_ serviceType: Service.Type, withArguments arguments: ArgumentProtocol...) throws -> Service {
        try resolve(serviceType, withArguments: arguments)
    }

    func resolve<Service, Key: Hashable>(_ serviceType: Service.Type, forKey key: Key, withArguments arguments: ArgumentProtocol...) throws -> Service {
        try resolve(serviceType, forKey: key, withArguments: arguments)
    }
    
    /// Resolves a `serviceType` service, using additional `arguments`.
    ///
    /// You can use this method when you need to specify custom arguments for `init()`
    /// method of the component as well as for the property injection.
    /// Parameters are matched by the type specified and always override
    /// all services registered in container.
    ///
    /// - Parameter serviceType: The type of resolved service.
    /// - Parameter arguments: The array of arguments that are used to create
    /// a new instance of component.
    ///
    /// - Returns: An instance of a component that provides `serviceType` service.
    /// - Attention: Parameters will be ignored for single-instance component if the instance
    /// has been already created.
    /// - Throws: `ContainerError`.
    ///
    func resolve<Service>(_ serviceType: Service.Type, withArguments arguments: Any...) throws -> Service {
        try resolve(serviceType, withArguments: convertArguments(arguments))
    }
    
    func resolve<Service, Key: Hashable>(_ serviceType: Service.Type, forKey key: Key, withArguments arguments: Any...) throws -> Service {
        try resolve(serviceType, forKey: key, withArguments: convertArguments(arguments))
    }
    
    // MARK: Resolve Optional

    /// Resolves an optional `serviceType` service.
    ///
    /// - Parameter serviceType: The type of resolved service.
    /// - Returns: An instance of a component that provides `serviceType` service, if registered; `nil` otherwise.
    /// - Throws: `ContainerError`.
    ///
    func resolveOptional<Service>(_ serviceType: Service.Type) throws -> Service? {
        try castOrThrowOptional(try resolveAnyOptional(serviceType), to: serviceType)
    }
    
    func resolveOptional<Service, Key: Hashable>(_ serviceType: Service.Type, forKey key: Key) throws -> Service? {
        try castOrThrowOptional(try resolveAnyOptional(serviceType, forKey: key), to: serviceType)
    }

    /// Resolves an optional `serviceType` service, using additional `arguments`.
    ///
    /// You can use this method when you need to specify custom arguments for `init()`
    /// method of the component as well as for the property injection.
    /// Parameters are matched by the type specified and always override
    /// all services registered in container.
    ///
    /// - Parameter serviceType: The type of resolved service.
    /// - Parameter arguments: The array of arguments that are used to create
    /// a new instance of component.
    ///
    /// - Attention: Parameters will be ignored for single-instance component if the instance
    /// has been already created.
    /// - Returns: The instance of component if registered; `nil` otherwise.
    /// - Throws: `ContainerError`.
    ///
    func resolveOptional<Service>(_ serviceType: Service.Type, withArguments arguments: [ArgumentProtocol]) throws -> Service? {
        try castOrThrowOptional(try resolveAnyOptional(serviceType, withArguments: arguments), to: serviceType)
    }

    func resolveOptional<Service, Key: Hashable>(_ serviceType: Service.Type, forKey key: Key, withArguments arguments: [ArgumentProtocol]) throws -> Service? {
        try castOrThrowOptional(try resolveAnyOptional(serviceType, forKey: key, withArguments: arguments), to: serviceType)
    }
    
    /// Resolves an optional `serviceType` service, using additional `arguments`.
    /// Uses `arguments` when creating a new instance.
    ///
    /// You can use this method when you need to specify custom arguments for `init()`
    /// method of the component as well as for the property injection.
    /// Parameters are matched by the type specified and always override
    /// all services registered in container.
    ///
    /// - Parameter serviceType: The type of resolved service.
    /// - Parameter arguments: The array of arguments that are used to create
    /// a new instance of component.
    ///
    /// - Attention: Parameters will be ignored for single-instance component if the instance
    /// has been already created.
    /// - Returns: The instance of component if registered; `nil` otherwise.
    /// - Throws: `ContainerError`.
    ///
    func resolveOptional<Service>(_ serviceType: Service.Type, withArguments arguments: ArgumentProtocol...) throws -> Service? {
        try resolveOptional(serviceType, withArguments: arguments)
    }
    
    func resolveOptional<Service, Key: Hashable>(_ serviceType: Service.Type, forKey key: Key, withArguments arguments: ArgumentProtocol...) throws -> Service? {
        try resolveOptional(serviceType, forKey: key, withArguments: arguments)
    }

    /// Resolves an optional `serviceType` service, using additional `arguments`.
    /// Uses `arguments` when creating a new instance.
    ///
    /// You can use this method when you need to specify custom arguments for `init()`
    /// method of the component as well as for the property injection.
    /// Parameters are matched by the type specified and always override
    /// all services registered in container.
    ///
    /// - Parameter serviceType: The type of resolved service.
    /// - Parameter parameters: The array of arguments that are used to create
    /// a new instance of component.
    ///
    /// - Attention: Parameters will be ignored for single-instance component if the instance
    /// has been already created.
    /// - Returns: The instance of component if registered; `nil` otherwise.
    /// - Throws: `ContainerError`.
    ///
    func resolveOptional<Service>(_ serviceType: Service.Type, withArguments arguments: Any...) throws -> Service? {
        try resolveOptional(serviceType, withArguments: convertArguments(arguments))
    }
    
    func resolveOptional<Service, Key: Hashable>(_ serviceType: Service.Type, forKey key: Key, withArguments arguments: Any...) throws -> Service? {
        try resolveOptional(serviceType, forKey: key, withArguments: convertArguments(arguments))
    }
    
    // MARK: Resolve All
    
    func resolveAll<Service>(of serviceType: Service.Type) throws -> [Service] {
        try resolveAll(serviceType, withArguments: nil).map {
            try castOrThrow($0, to: serviceType)
        }
    }
    
    func resolveAll<Service, Key: Hashable>(of serviceType: Service.Type, forKey key: Key) throws -> [Service] {
        try resolveAll(serviceType, forKey: key, withArguments: nil).map {
            try castOrThrow($0, to: serviceType)
        }
    }
    
    func resolveAll<Service>(of serviceType: Service.Type, withArguments arguments: [ArgumentProtocol]) throws -> [Service] {
        try resolveAll(serviceType, withArguments: arguments).map {
            try castOrThrow($0, to: serviceType)
        }
    }    
    
    func resolveAll<Service>(of serviceType: Service.Type, withArguments arguments: ArgumentProtocol...) throws -> [Service] {
        try resolveAll(of: serviceType, withArguments: arguments)
    }
    
    func resolveAll<Service>(of serviceType: Service.Type, withArguments arguments: Any...) throws -> [Service] {
        try resolveAll(of: serviceType, withArguments: convertArguments(arguments))
    }
    
    // MARK: Resolve Any

    func resolveAny(_ serviceType: Any.Type) throws -> Any {
        try internalResolveAny(serviceType, withArguments: nil)
    }
    
    func resolveAny<Key: Hashable>(_ serviceType: Any.Type, forKey key: Key) throws -> Any {
        try internalResolveAny(serviceType, forKey: key, withArguments: nil)
    }

    func resolveAny(_ serviceType: Any.Type, withArguments arguments: [ArgumentProtocol]) throws -> Any {
        try internalResolveAny(serviceType, withArguments: arguments)
    }
    
    func resolveAny<Key: Hashable>(_ serviceType: Any.Type, forKey key: Key, withArguments arguments: [ArgumentProtocol]) throws -> Any {
        try internalResolveAny(serviceType, forKey: key, withArguments: arguments)
    }

    func resolveAny(_ serviceType: Any.Type, withArguments arguments: ArgumentProtocol...) throws -> Any {
        try resolveAny(serviceType, withArguments: arguments)
    }
    
    func resolveAny<Key: Hashable>(_ serviceType: Any.Type, forKey key: Key, withArguments arguments: ArgumentProtocol...) throws -> Any {
        try resolveAny(serviceType, forKey: key, withArguments: arguments)
    }

    func resolveAny(_ serviceType: Any.Type, withArguments arguments: Any...) throws -> Any {
        try resolveAny(serviceType, withArguments: convertArguments(arguments))
    }
    
    func resolveAny<Key: Hashable>(_ serviceType: Any.Type, forKey key: Key, withArguments arguments: Any...) throws -> Any {
        try resolveAny(serviceType, forKey: key, withArguments: convertArguments(arguments))
    }
    
    func resolveAnyOptional(_ serviceType: Any.Type) throws -> Any? {
        try resolveAnyOptional(serviceType, withArguments: nil)
    }
    
    func resolveAnyOptional<Key: Hashable>(_ serviceType: Any.Type, forKey key: Key) throws -> Any? {
        try resolveAnyOptional(serviceType, forKey: key, withArguments: nil)
    }


    // MARK: Private

    private func internalResolveAny(_ serviceType: Any.Type,
                                    withArguments arguments: [ArgumentProtocol]?) throws -> Any {
        guard let anyInstance = try resolveAnyOptional(serviceType, withArguments: arguments) else {
            throw ContainerError.serviceNotFound(serviceType: serviceType)
        }
        return anyInstance
    }
    
    private func internalResolveAny<Key: Hashable>(_ serviceType: Any.Type,
                                         forKey key: Key,
                                    withArguments arguments: [ArgumentProtocol]?) throws -> Any {
        guard let anyInstance = try resolveAnyOptional(serviceType, forKey: key, withArguments: arguments) else {
            throw ContainerError.serviceNotFound(serviceType: serviceType)
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
            throw ContainerError.invalidRegistration(desiredType: Service.self,
                    actualType: type(of: anyInstance))
        }
        return typedInstance
    }

    private func convertArguments(_ arguments: [Any]) -> [ArgumentProtocol] {
        arguments.map {AnyArgument($0, type(of: $0))}
    }
}
