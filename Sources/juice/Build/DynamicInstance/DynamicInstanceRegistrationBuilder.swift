//
// Copyright © 2019 Juice Project. All rights reserved.
//

public struct DynamicInstanceRegistrationBuilder<Type> : ComponentServicesBuilder, PropertyInjectionBuilder {
    let registrationPrototype: DynamicInstanceRegistrationPrototype<Type>

    internal init(registrationPrototype: DynamicInstanceRegistrationPrototype<Type>) {
        self.registrationPrototype = registrationPrototype
    }

    @discardableResult
    public func `as`<TService>(_ serviceType: TService.Type) -> DynamicInstanceRegistrationBuilder {
        registrationPrototype.services.append(serviceType)
        return self
    }

    @discardableResult
    public func asSelf() -> DynamicInstanceRegistrationBuilder {
        registrationPrototype.services.append(Type.self)
        return self
    }

    @discardableResult
    public func injectDependency<PropertyType>(into keyPath: WritableKeyPath<Type, PropertyType?>) -> DynamicInstanceRegistrationBuilder {
        registrationPrototype.propertyInjectors.append(TypedPropertyInjector<Type, PropertyType>(keyPath))
        return self
    }

    @discardableResult
    public func injectOptionalDependency<PropertyType>(into keyPath: WritableKeyPath<Type, PropertyType?>) -> DynamicInstanceRegistrationBuilder {
        registrationPrototype.propertyInjectors.append(OptionalTypedPropertyInjector<Type, PropertyType>(keyPath))
        return self
    }
}
