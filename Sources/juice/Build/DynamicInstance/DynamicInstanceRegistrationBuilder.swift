//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

public struct DynamicInstanceRegistrationBuilder<Type> {
    let registrationPrototype: DynamicInstanceRegistrationPrototype<Type>

    internal init(registrationPrototype: DynamicInstanceRegistrationPrototype<Type>) {
        self.registrationPrototype = registrationPrototype
    }

    /// Registers component by `serviceType` type.
    ///
    /// For example:
    ///
    ///     let container = try Container { builder in
    ///         builder.register(injectable: Apple.self)
    ///             .singleInstance()
    ///             .as(Fruit.self)
    ///
    ///     let fruit = try container.resolve(Fruit.self)
    ///
    /// - Prameter serviceType: The type of service that this component provides.
    ///
    @discardableResult
    public func `as`<TService>(_ serviceType: TService.Type) -> DynamicInstanceRegistrationBuilder {
        registrationPrototype.services.append(serviceType)
        return self
    }

    /// Registers component by its own type.
    ///
    /// For example:
    ///
    ///     let container = try Container { builder in
    ///         builder.register(injectable: Apple.self)
    ///             .singleInstance()
    ///             .asSelf()
    ///
    ///     let apple = try container.resolve(Apple.self)
    @discardableResult
    public func asSelf() -> DynamicInstanceRegistrationBuilder {
        registrationPrototype.services.append(Type.self)
        return self
    }

    /// Tells container to inject a dependency at given `keyPath`
    ///
    /// For example:
    ///
    ///     class Jam: Injectable {
    ///         var fruit: Fruit!
    ///         var spice: Spice?
    ///
    ///         required init() {
    ///         }
    ///     }
    ///     let container = try Container { builder in
    ///         ...
    ///         builder.register(injectable: Jam.self)
    ///                 .singleInstance()
    ///                 .asSelf()
    ///                 .injectDependency(into: \.fruit)
    ///                 .injectDependency(into: \.spice)
    ///     }
    ///
    @discardableResult
    public func injectDependency<PropertyType>(into keyPath: WritableKeyPath<Type, PropertyType?>) -> DynamicInstanceRegistrationBuilder {
        registrationPrototype.propertyInjectors.append(TypedPropertyInjector<Type, PropertyType>(keyPath))
        return self
    }
    
    /// Tells container to inject an optional dependency at given `keyPath`
    ///
    ///
    @discardableResult
    public func injectOptionalDependency<PropertyType>(into keyPath: WritableKeyPath<Type, PropertyType?>) -> DynamicInstanceRegistrationBuilder {
        registrationPrototype.propertyInjectors.append(OptionalTypedPropertyInjector<Type, PropertyType>(keyPath))
        return self
    }
}
