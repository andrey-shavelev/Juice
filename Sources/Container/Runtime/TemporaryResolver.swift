//
//  TemporaryResolver.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/05/2019.
//

public struct TemporaryResolver {
    
    let container: Container
    
    init(_ container: Container) {
        self.container = container
    }
    
    func resolve<TInstance>(_ serviceType: TInstance.Type) throws -> TInstance {
        let serviceKey = ServiceKey(for: serviceType)
        
        guard let implementorFactory = container.registrations[serviceKey] else {
            throw ContainerError.serviceNotFound(serviceType: serviceType)
        }
        
        let rawInstance = try implementorFactory.resolve(resolveDependenciesFrom: self)
        
        guard let typedInstance = rawInstance as? TInstance else {
            throw ContainerError.invalidType(expectedType: TInstance.self, actualType: type(of: rawInstance))
        }
        
        return typedInstance
    }
}
