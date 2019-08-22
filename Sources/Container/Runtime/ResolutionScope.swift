//
//  ContextResolver
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

struct ResolutionScope: Scope {
    public var isValid: Bool {
        return container != nil
    }

    weak var container: Container?

    init(_ container: Container) {
        self.container = container
    }

    public func resolve<TInstance>(_ serviceType: TInstance.Type) throws -> TInstance {
        guard let container = container else {
            throw ContainerRuntimeError.invalidScope()
        }
        return try resolveInternal(serviceType, ScopeLocator(container))
    }

    public func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: [Any]) throws -> Service {
        guard let container = container else {
            throw ContainerRuntimeError.invalidScope()
        }
        let scopeLocator = ParameterizedScopeLocator(container: container, parameters: parameters)
        return try resolveInternal(serviceType, scopeLocator)
    }

    func resolveInternal<TInstance>(_ serviceType: TInstance.Type,
                                    _ scopeLocator: ResolutionScopeLocator) throws -> TInstance {
        guard let container = container else {
            throw ContainerRuntimeError.invalidScope()
        }

        let serviceKey = TypeKey(for: serviceType)

        guard let registration = container.findRegistration(matchingKey: serviceKey) else {
            throw ContainerRuntimeError.serviceNotFound(serviceType: serviceType)
        }

        let rawInstance = try registration.resolveServiceInstance(
                storageLocator: container,
                scopeLocator: scopeLocator)

        guard let typedInstance = rawInstance as? TInstance else {
            throw ContainerRuntimeError.invalidRegistration(desiredType: TInstance.self,
                    actualType: type(of: rawInstance))
        }

        return typedInstance
    }
}
