//
// Copyright © 2019 Juice Project. All rights reserved.
//

/// A scope containing a set of services.
///
/// At runtime it could be a `Container` itself or wrapper-type that might hold additional arguments.
///
public protocol Scope {
    func resolveAnyOptional(_ serviceType: Any.Type, withArguments arguments: [ArgumentProtocol]?) throws -> Any?
}

/// A scope containing a set of dependencies for a component being created.
///
/// At runtime `CurrentScope` is represented by a wrapper-type over a `Container` that might hold additional arguments.
/// Any component could access `CurrentScope` from its init() method.
/// Please note, that your component may also keeping a reference to `CurrentScope` to, for example, resolve dependencies at a later stage.
/// However, `CurrentScope` itself keeps a weak reference to the container.
/// That means that if by any mistake your component has a longer lifetime than its container,
/// `CurrentScope` might become invalid and resolve method will throw an error.
/// If your component by design lives longer then the container, you need to check the
/// `isValid` property of `CurrentScope` to determine if it still valid.
///
public protocol CurrentScope: Scope {
    /// Shows if Scope is still valid and could be used to resolve dependencies.
    ///
    /// `CurrentScope` keeps a weak reference to underling container and
    /// may become invalid if container gets deallocated.
    ///
    var isValid: Bool { get }

    /// Creates a child `Container`.
    ///
    /// - Returns: an empty child `Container`.
    ///
    func createChildContainer() throws -> Container

    /// Creates a named child `Container`.
    ///
    /// - Parameter name: The name for a new container.
    /// - Returns: an empty child `Container` with `name`.
    ///
    func createChildContainer(name: String?) throws -> Container
    
    /// Creates a child `Container`.
    ///
    /// - Parameter buildFunc: The closure to registers additional components.
    /// - Returns: A child `Container`.
    ///
    func createChildContainer(_ buildFunc: (ContainerBuilder) -> Void) throws -> Container
    
    /// Creates a child `Container`.
    ///
    /// - Parameter name: The  name for a new container.
    /// - Parameter buildFunc: The closure to registers additional components.
    /// - Returns: A child `Container`.
    ///
    func createChildContainer(name: String?, _ buildFunc: (ContainerBuilder) -> Void) throws -> Container
}

public extension Scope {
    /// Resolves a `serviceType` service.
    ///
    /// - Returns: An instance of a component that provides `serviceType` service.
    /// - Parameter serviceType: The type of required service.
    /// - Throws: `ContainerError`.
    ///
    func resolve<Service>(_ serviceType: Service.Type) throws -> Service {
        try castOrThrow(try resolveAny(serviceType), to: serviceType)
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

    /// Resolves an optional `serviceType` service.
    ///
    /// - Parameter serviceType: The type of resolved service.
    /// - Returns: An instance of a component that provides `serviceType` service, if registered; `nil` otherwise.
    /// - Throws: `ContainerError`.
    ///
    func resolveOptional<Service>(_ serviceType: Service.Type) throws -> Service? {
        try castOrThrowOptional(try resolveAnyOptional(serviceType), to: serviceType)
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

    func resolveAny(_ serviceType: Any.Type) throws -> Any {
        try internalResolveAny(serviceType, withArguments: nil)
    }

    func resolveAny(_ serviceType: Any.Type, withArguments arguments: [ArgumentProtocol]) throws -> Any {
        try internalResolveAny(serviceType, withArguments: arguments)
    }

    func resolveAny(_ serviceType: Any.Type, withArguments arguments: ArgumentProtocol...) throws -> Any {
        try resolveAny(serviceType, withArguments: arguments)
    }

    func resolveAny(_ serviceType: Any.Type, withArguments arguments: Any...) throws -> Any {
        try resolveAny(serviceType, withArguments: convertArguments(arguments))
    }

    func resolveAnyOptional(_ serviceType: Any.Type) throws -> Any? {
        try resolveAnyOptional(serviceType, withArguments: nil)
    }

    private func internalResolveAny(_ serviceType: Any.Type,
                                    withArguments arguments: [ArgumentProtocol]?) throws -> Any {
        guard let anyInstance = try resolveAnyOptional(serviceType, withArguments: arguments) else {
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
