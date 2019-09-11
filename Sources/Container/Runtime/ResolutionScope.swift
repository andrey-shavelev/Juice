//
//  ContextResolver
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

struct ResolutionScope: Scope {
    weak var container: Container?

    init(_ container: Container) {
        self.container = container
    }

    public var isValid: Bool {
        return container != nil
    }

    func resolveAnyOptional(_ serviceType: Any.Type, withParameters parameters: [Parameter]?) throws -> Any? {
        guard let container = container else {
            throw ContainerRuntimeError.invalidScope()
        }
        let scopeLocator = createScopeLocator(container, parameters)
        let serviceKey = TypeKey(for: serviceType)
        guard let registration = container.findRegistration(matchingKey: serviceKey) else {
            return nil
        }
        return try registration.resolveServiceInstance(
                storageLocator: container,
                scopeLocator: scopeLocator)
    }

    private func createScopeLocator(_ container: Container, _ parameters: [Parameter]?) -> ResolutionScopeLocator {
        if let parameters = parameters {
            return ParameterizedScopeLocator(container: container, parameters: parameters)
        }
        return ScopeLocator(container)
    }
}
