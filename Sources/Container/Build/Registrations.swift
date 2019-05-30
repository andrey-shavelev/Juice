//
//  Registrations.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class TypeRegistrationBuilder {
    let builder: ContainerBuilder
    let serviceRegistration: ServiceRegistration
    
    init(_ builder: ContainerBuilder, _ implementorFactory: InstanceFactory) {
        self.builder = builder
        self.serviceRegistration = ServiceRegistration(factory: implementorFactory)
    }
    
    @discardableResult
    public func `as`<TService>(_ service: TService.Type) -> TypeRegistrationBuilder {
        let serviceKey = ServiceKey(for: service)
        builder.registrations[serviceKey] = serviceRegistration
        return self
    }
    
    @discardableResult
    public func singleInstance() -> TypeRegistrationBuilder {
        return self
    }
}
