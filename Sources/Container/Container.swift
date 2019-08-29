//
//  Container.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class Container: Scope, InstanceStorage, InstanceStorageLocator {
    public var isValid = true

    let registrations: [TypeKey: ServiceRegistration]
    var instances = [TypeKey: Any]()
    let key: ScopeKey
    let parent: Container?

    convenience init(_ buildFunc: (ContainerBuilder) -> Void) throws {
        try self.init(parent: nil, name: nil, buildFunc: buildFunc)
    }

    private init(parent: Container?, name: String? = nil, buildFunc: (ContainerBuilder) -> Void) throws {
        self.parent = parent
        if let name = name {
            self.key = .named(name: name)
        } else {
            self.key = .unique(key: UniqueScopeKey())
        }
        self.registrations = try ContainerBuilder(scopeKey: key).build(buildFunc)
    }

    public func createChildContainer(name: String? = nil) throws -> Container {
        return try Container(parent: self, name: name, buildFunc: { _ in })
    }

    public func createChildContainer(name: String? = nil, _ buildFunc: (ContainerBuilder) -> Void) throws -> Container {
        return try Container(parent: self, buildFunc: buildFunc)
    }

    public func resolve<TService>(_ serviceType: TService.Type) throws -> TService {
        return try ResolutionScope(self).resolve(serviceType)
    }

    public func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: [Any]) throws -> Service {
        return try ResolutionScope(self).resolve(serviceType, withParameters: parameters)
    }

    func getOrCreate<Instance>(instanceOfType type: Instance.Type,
                               usingFactory factory: InstanceFactory,
                               withDependenciesFrom scope: Scope) throws
                    -> Any {
        // TODO if one class registered twice with different services it should return two different instances
        let typeKey = TypeKey(for: type)

        if let existingInstance = instances[typeKey] {
            return existingInstance
        }

        let newInstance = try factory.create(withDependenciesFrom: scope)
        instances[typeKey] = newInstance
        return newInstance
    }

    func findRegistration(matchingKey serviceKey: TypeKey) -> ServiceRegistration? {
        return registrations[serviceKey] ?? parent?.findRegistration(matchingKey: serviceKey);
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