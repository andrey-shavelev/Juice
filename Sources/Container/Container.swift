//
//  Container.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class Container: Scope, InstanceStorage, InstanceStorageLocator {
    public var isValid = true

    let dynamicRegistrationsSources: [DynamicRegistrationsSource]
    var registrations: [TypeKey: ServiceRegistration]
    var instances = [StorageKey: Any]()

    let key: ScopeKey
    let parent: Container?

    public convenience init () throws {
        try self.init { builder in
        }
    }

    public convenience init(_ buildFunc: (ContainerBuilder) -> Void) throws {
        try self.init(parent: nil, name: nil, buildFunc: buildFunc)
    }

    private init(parent: Container?, name: String? = nil, buildFunc: (ContainerBuilder) -> Void) throws {
        self.parent = parent
        if let name = name {
            self.key = .named(name: name)
        } else {
            self.key = .unique(key: UniqueScopeKey())
        }

        let prototype = try ContainerBuilder(scopeKey: key).build(buildFunc)

        self.registrations = prototype.registrations
        self.dynamicRegistrationsSources = prototype.dynamicRegistrationSources
    }

    public func resolveAnyOptional(_ serviceType: Any.Type, withParameters parameters: [Parameter]?) throws -> Any? {
        return try ResolutionScope(self).resolveAnyOptional(serviceType, withParameters: parameters)
    }

    public func createChildContainer(name: String? = nil) throws -> Container {
        return try Container(parent: self, name: name, buildFunc: { _ in })
    }

    public func createChildContainer(name: String? = nil, _ buildFunc: (ContainerBuilder) -> Void) throws -> Container {
        return try Container(parent: self, buildFunc: buildFunc)
    }

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

    func findRegistration(matchingKey serviceKey: TypeKey) -> ServiceRegistration? {

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