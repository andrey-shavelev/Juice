//
//  Container.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class Container : Scope, InstanceStorage, InstanceStorageLocator {
    public var isValid = true

    let registrations: [TypeKey: ServiceRegistration]
    var instances = [TypeKey: Any]()
    let key = ScopeKey.unique(key: UniqueScopeKey())
    let parent: Container?

    init(_ buildFunc: (ContainerBuilder) -> Void) {

        let builder = ContainerBuilder(scopeKey: key)
        buildFunc(builder)

        self.registrations = builder.build()
        self.parent = nil
    }

    private init(_ parent: Container){
        self.parent = parent
        self.registrations = [TypeKey: ServiceRegistration]()
    }

    public func resolve<TService>(_ serviceType: TService.Type) throws -> TService {
        return try ResolutionScope(self).resolve(serviceType)
    }

    public func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: [Any]) throws -> Service {
        return try ResolutionScope(self).resolve(serviceType, withParameters: parameters)
    }

    public func openChildScope() -> Scope {
        return Container(self)
    }

    func getOrCreate<Instance>(instanceOfType type: Instance.Type,
                               usingFactory factory: InstanceFactory,
                               withDependenciesFrom scope: Scope) throws
                    -> (InstanceFlag, Any) {
        // TODO if one class registered twice with different services it should return two different instances
        let typeKey = TypeKey(for: type)

        if let existingInstance = instances[typeKey] {
            return (.existing, existingInstance)
        }

        let newInstance = try factory.create(withDependenciesFrom: scope)
        instances[typeKey] = newInstance
        return (.new, newInstance)
    }

    func findRegistration(matchingKey serviceKey: TypeKey) -> ServiceRegistration? {
        return registrations[serviceKey] ?? parent?.findRegistration(matchingKey: serviceKey);
    }

    func findContainer(matchingKey key: ScopeKey) -> Container? {
        var result: Container? = self

        while (result != nil){
            if (result?.key.matches(key) == true){
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