//
//  ContextResolver
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

public struct ResolutionScope : Scope {
    
    public var isValid: Bool {
        return container != nil
    }
    
    weak var container: Container?
    
    init(_ container: Container) {
        self.container = container
    }
    
    public func resolve<TInstance>(_ serviceType: TInstance.Type) throws -> TInstance {
        return try resolveInternal(serviceType, withDependenciesResolvedFrom: self)
    }
    
    public func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: [Any]) throws -> Service {
        return try resolveInternal(serviceType,
                                   withDependenciesResolvedFrom: ParameterizedResolutionScope(parentScope: self, parameters: parameters))
    }
    
    func resolveInternal<TInstance>(_ serviceType: TInstance.Type,
                                    withDependenciesResolvedFrom scope: Scope) throws -> TInstance {
        guard let container = container else {
            throw ContainerRuntimeError.invalidScope()
        }
        
        let serviceKey = TypeKey(for: serviceType)
        
        guard let registration = container.registrations[serviceKey] else {
            throw ContainerRuntimeError.serviceNotFound(serviceType: serviceType)
        }
        
        let rawInstance = try registration.resolveServiceInstance(withDependenciesResolvedFrom: scope)
        
        guard let typedInstance = rawInstance as? TInstance else {
            throw ContainerRuntimeError.invalidRegistration(desiredType: TInstance.self,
                                                            actualType: type(of: rawInstance))
        }
        
        return typedInstance
    }
}
