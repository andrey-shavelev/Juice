//
//  Registrations.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public struct DynamicInstanceRegistrationBuilder<Type> {
    let builder: ContainerBuilder
    let serviceRegistration: DynamicInstanceRegistration<Type>
    
    internal init(
        serviceRegistration: DynamicInstanceRegistration<Type>,
        builder: ContainerBuilder) {
        self.serviceRegistration = serviceRegistration
        self.builder = builder
    }
    
    @discardableResult
    public func `as`<TService>(_ serviceType: TService.Type) -> DynamicInstanceRegistrationBuilder {
        builder.registrationsDictionary[TypeKey(for: serviceType)] = serviceRegistration
        return self
    }
    
    @discardableResult
    public func asSelf() -> DynamicInstanceRegistrationBuilder {
        builder.registrationsDictionary[TypeKey(for: Type.self)] = serviceRegistration
        return self
    }
    
    @discardableResult
    public func injectDependency<PropertyType>(into keyPath: WritableKeyPath<Type, PropertyType?>) -> DynamicInstanceRegistrationBuilder {
        serviceRegistration.propertyInjectors.append(TypedPropertyInjector<Type, PropertyType>(keyPath))
        return self
    }
}
