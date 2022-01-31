//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

/// Dependency injection container.
///
/// Register components using one of `init` methods:
///
///     let container = try Container { builder in
///         builder.register(injectable: Apple.self)
///                .singleInstance()
///                .as(Fruit.self)
///         builder.register(injectable: FreshJuice.self)
///                .singleInstance()
///                .as(Juice.self)
///     }
///
/// Resolve services using `Scope` protocol methods:
///
///     let appleJuice = try container.resolve(Juice.self)
///
/// - SeeAlso: `Scope`
///
public class Container: Scope {
    var dynamicRegistrationsSources: [DynamicRegistrationsSource]
    var registrations: [ServiceKey: ServiceRegistration]
    var instances = [StorageKey: Any]()
    let key: ScopeKey
    let parent: Container?
    var globalScopeUuid: UUID?

    /// Creates an empty `Container`
    public convenience init () {
        self.init(parent: nil, name: nil)
    }

    /// Creates a `Container` with components registered in `buildFunc`.
    ///
    /// - Parameter buildFunc: The closure that registers all required components.
    ///
    /// - Throws: ContainerRuntimeError in case of an error in registrations.
    ///
    public convenience init(_ buildFunc: (_ builder: ContainerBuilder) -> Void) throws {
        try self.init(parent: nil, name: nil, buildFunc: buildFunc)
    }

    /// Resolves an optional service from container.
    ///
    /// - Parameter serviceType: The type of the service to resolve.
    /// - Parameter withParameters: The array of arguments that are passed to component's `init` method
    ///     when new instance is created.
    ///
    /// - Returns: An instance of component that provides requested service if any registered;
    /// returns nil otherwise.
    ///
    /// - Throws: `ContainerRuntimeError`.
    ///
    /// - Attention: This method does not check if the component provides the requested service,
    /// and returns exactly what was registered during container build.
    public func resolveAnyOptional(_ serviceType: Any.Type, withArguments arguments: [ArgumentProtocol]?) throws -> Any? {
        try resolveAnyOptional(ServiceKey(type: serviceType), arguments)
    }
    
    public func resolveAnyOptional<Key>(_ serviceType: Any.Type, forKey key: Key, withArguments arguments: [ArgumentProtocol]?) throws -> Any? where Key : Hashable {
        try resolveAnyOptional(ServiceKey(type: serviceType, key: key), arguments)
    }
        
    public func resolveAll(_ serviceType: Any.Type, withArguments arguments: [ArgumentProtocol]?) throws -> [Any] {
        try resolveAll(ServiceKey(type: serviceType), arguments)
    }
    
    public func resolveAll<Key>(_ serviceType: Any.Type, forKey key: Key, withArguments arguments: [ArgumentProtocol]?) throws -> [Any] where Key : Hashable {
        try resolveAll(ServiceKey(type: serviceType, key: key), arguments)
    }

    /// Creates and returns a child `Container`.
    ///
    /// - Parameter name: The optional name for a new container.
    ///
    /// - Returns: an empty child `Container` with optional `name`.
    ///
    public func createChildContainer(name: String? = nil) -> Container {
        return Container(parent: self, name: name)
    }

    /// Creates and returns a child `Container`.
    ///
    /// - Parameter name: The optional name for a new container.
    /// - Parameter buildFunc: The closure to registers additional components.
    ///
    /// - Returns: A child `Container` with optional `name` and additional components registered in `buildFunc`.
    ///
    public func createChildContainer(name: String? = nil, _ buildFunc: (ContainerBuilder) -> Void) throws -> Container {
        return try Container(parent: self, buildFunc: buildFunc)
    }
    
    public func setAsGlobalScope() {
        globalScopeUuid = ScopeStack.setGlobalScope(self)
    }
    
    public func resignGlobalScope() {
        guard let globalScopeUuid = globalScopeUuid else {
            return
        }
        
        ScopeStack.resignGlobalScope(withUuid: globalScopeUuid)
    }
    
    // MARK: Private
    
    private convenience init(parent: Container?,
                 name: String? = nil,
                 buildFunc: (ContainerBuilder) -> Void) throws {
        self.init(parent: parent, name: name)
        try ContainerBuilder(self).build(buildFunc)
    }
    
    private init (parent: Container?,
                  name: String? = nil) {
        self.parent = parent
        self.key = ScopeKey.create(fromName: name)
        self.registrations = [ServiceKey: ServiceRegistration]()
        self.dynamicRegistrationsSources = [
            OptionalDynamicRegistrationSource(),
            FactoryDynamicRegistrationSource(),
            LazyDynamicRegistrationSource(),
            ArrayDynamicRegistrationSource()
        ]
    }
    
    private func resolveAnyOptional(_ serviceKey: ServiceKey, _ arguments: [ArgumentProtocol]?) throws -> Any? {
        guard let registration = findRegistration(matchingKey: serviceKey) else {
            return nil
        }

        let scopeLocator = createScopeLocator(arguments)

        return try registration.resolveServiceInstance(
                storageLocator: self,
                scopeLocator: scopeLocator)
    }
    
    func resolveAll(_ serviceKey: ServiceKey, _ arguments: [ArgumentProtocol]?) throws -> [Any] {
        guard let registration = findRegistration(matchingKey: serviceKey) else {
            return []
        }

        let scopeLocator = createScopeLocator(arguments)
        
        if let multiServiceRegistration = registration as? MultiServiceRegistration {
            return try multiServiceRegistration.resolveAllServiceInstances(
                    storageLocator: self,
                    scopeLocator: scopeLocator)
        } else {
            return [try registration.resolveServiceInstance(
                    storageLocator: self,
                    scopeLocator: scopeLocator)]
        }
    }

    private func findRegistration(matchingKey serviceKey: ServiceKey) -> ServiceRegistration? {

        if let existingRegistration = registrations[serviceKey] ?? parent?.findRegistration(matchingKey: serviceKey){
            return existingRegistration
        }

        for dynamicRegistrationsSource in dynamicRegistrationsSources {
            if let dynamicRegistration = dynamicRegistrationsSource.FindRegistration(forType: serviceKey.type) {
                registrations[serviceKey] = dynamicRegistration
                return dynamicRegistration
            }
        }

        return nil
    }

    private func createScopeLocator(_ parameters: [ArgumentProtocol]?) -> ResolutionScopeLocator {
        if let parameters = parameters {
            return ParameterizedScopeLocator(self, parameters)
        }
        return ScopeLocator(self)
    }
}


// MARK: Storage

extension Container: InstanceStorage, InstanceStorageLocator {
    func getOrCreate(storageKey: StorageKey,
                     usingFactory factory: InstanceFactory,
                     withDependenciesFrom scope: Scope) throws -> Any {
        if let existingInstance = instances[storageKey] {
            return existingInstance
        }
        let newInstance = try factory.create(withDependenciesFrom: scope)
        instances[storageKey] = newInstance
        return newInstance
    }
    
    func findContainer(matchingKey key: ScopeKey) -> Container? {
        var result: Container? = self
        
        while (result != nil) {
            if (result?.key.matches(key) == true) {
                return result;
            }
            
            result = result?.parent
        }
        
        return nil
    }
    
    func findStorage(matchingKey key: ScopeKey) -> InstanceStorage? {
        return findContainer(matchingKey: key)
    }
}
