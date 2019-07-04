//
//  Container.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class Container : Scope {
    
    public var isValid = true
    
    let registrations: [TypeKey : ServiceRegistration]
    
    init(_ buildFunc: (ContainerBuilder) -> Void) {
        let builder = ContainerBuilder()
        buildFunc(builder)
        
        self.registrations = builder.build()
    }
    
    public func resolve<TService>(_ serviceType: TService.Type) throws -> TService {        
        return try ResolutionScope(self).resolve(serviceType)
    }
    
    public func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: [Any]) throws -> Service {
        return try ResolutionScope(self).resolve(serviceType, withParameters: parameters)
    }
}
