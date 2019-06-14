//
//  TemporaryResolver.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

public struct ContextResolver {
    
    let container: Container
    
    init(_ container: Container) {
        self.container = container
    }
    
    public func resolve<TInstance>(_ serviceType: TInstance.Type) throws -> TInstance {
        let serviceKey = TypeKey(for: serviceType)
        
        guard let registration = container.registrations[serviceKey] else {
            throw ContainerRuntimeError.serviceNotFound(serviceType: serviceType)
        }
        
        let rawInstance = try registration.resolveServiceInstance(withDependenciesResolvedFrom: self)
        
        guard let typedInstance = rawInstance as? TInstance else {
            throw ContainerRuntimeError.invalidRegistration(desiredType: TInstance.self,
                                                     actualType: type(of: rawInstance))
        }
        
        return typedInstance
    }
}
