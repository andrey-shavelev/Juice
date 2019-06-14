//
//  Registrations.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public struct TypeRegistrationBuilder<Type> {
    let builder: ContainerBuilder
    let serviceRegistration: TypedServiceRegistration
    
    internal init(
        serverRegistration: TypedServiceRegistration,
        builder: ContainerBuilder) {
        self.serviceRegistration = serverRegistration
        self.builder = builder
    }
    
    @discardableResult
    public func `as`<TService>(_ serviceType: TService.Type) -> TypeRegistrationBuilder {
        let serviceKey = TypeKey(for: serviceType)
        builder.registrationsDictionary[serviceKey] = serviceRegistration
        return self
    }
    
    @discardableResult
    public func asSelf() -> TypeRegistrationBuilder {
        builder.registrationsDictionary[TypeKey(for: Type.self)] = serviceRegistration
        return self
    }
    
    @discardableResult
    public func singleInstance() -> TypeRegistrationBuilder {
        serviceRegistration.serviceKind = .container
        return self
    }
    
    @discardableResult
    func instancePerDependency() -> TypeRegistrationBuilder {
        serviceRegistration.serviceKind = .dependency
        return self
    }
    
    @discardableResult
    public func injectDependency<PropertyType>(into keyPath: WritableKeyPath<Type, PropertyType?>) -> TypeRegistrationBuilder {
        serviceRegistration.propertyInjectors.append(TypedPropertyInjector<Type, PropertyType>(keyPath))
        return self
    }
}
