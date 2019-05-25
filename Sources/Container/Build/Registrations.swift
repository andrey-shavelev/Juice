//
//  Registrations.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class RegistrationBuilder<TImplementor : Injectable> {
    let builder: ContainerBuilder
    let serviceRegistration: ServiceRegistration
    
    init(_ builder: ContainerBuilder) {
        self.builder = builder
        self.serviceRegistration = ServiceRegistration(factory: InjectableImplementorFactory<TImplementor>())
    }
    
    @discardableResult
    public func `as`<TService>(_ service: TService.Type) -> RegistrationBuilder<TImplementor> {
        let serviceKey = ServiceKey(for: service)
        builder.registrations[serviceKey] = serviceRegistration
        return self
    }
    
    @discardableResult
    public func singleInstance() -> RegistrationBuilder<TImplementor> {
        return self
    }
}

public class RegistrationBuilderWithParameter<TImplementor : InjectableWithParameter> {
    let builder: ContainerBuilder
    
    init(_ builder: ContainerBuilder) {
        self.builder = builder
    }
    
    @discardableResult
    public func `as`<TService>(_ service: TService.Type) -> RegistrationBuilderWithParameter<TImplementor> {
        return self
    }
}
