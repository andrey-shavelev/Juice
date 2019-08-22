//
//  StaticInstanceRegistrationBuilder.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/06/2019.
//

public struct StaticInstanceRegistrationBuilder<Type> {
    let builder: ContainerBuilder
    let serviceRegistration: ExternalInstanceRegistration<Type>

    internal init(
            serviceRegistration: ExternalInstanceRegistration<Type>,
            builder: ContainerBuilder) {
        self.serviceRegistration = serviceRegistration
        self.builder = builder
    }

    @discardableResult
    public func `as`<TService>(_ serviceType: TService.Type) -> StaticInstanceRegistrationBuilder<Type> {
        builder.registrationsDictionary[TypeKey(for: serviceType)] = serviceRegistration
        return self
    }

    @discardableResult
    public func asSelf() -> StaticInstanceRegistrationBuilder<Type> {
        builder.registrationsDictionary[TypeKey(for: Type.self)] = serviceRegistration
        return self
    }
}
