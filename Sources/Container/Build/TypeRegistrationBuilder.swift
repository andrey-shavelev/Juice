//
//  Registrations.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public struct TypeRegistrationBuilder {
    let builder: ContainerBuilder
    let serviceRegistration: ServiceRegistration
    let instanceType: Any.Type
    
    init(_ builder: ContainerBuilder,
         _ implementorFactory: InstanceFactory,
         _ instanceType: Any.Type) {
        self.builder = builder
        self.serviceRegistration = ServiceRegistration(factory: implementorFactory)
        self.instanceType = instanceType
    }
    
    @discardableResult
    public func `as`<TService>(_ serviceType: TService.Type) -> TypeRegistrationBuilder {
        let serviceKey = ServiceKey(for: serviceType)
        builder.registrations[serviceKey] = serviceRegistration
        return self
    }
    
    @discardableResult
    public func asSelf() -> TypeRegistrationBuilder {
        let serviceKey = ServiceKey(for: instanceType)
        builder.registrations[serviceKey] = serviceRegistration
        return self
    }
    
    @discardableResult
    public func singleInstance() -> TypeRegistrationBuilder {
        return self
    }
}
