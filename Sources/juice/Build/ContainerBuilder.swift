//
// Copyright © 2019 Juice Project. All rights reserved.
//

/// A builder for component registrations
///
/// `ContainerBuilder` is used during creation of a new or child container.
///
public class ContainerBuilder {
    var registrationPrototypes = [ServiceRegistrationPrototype]()
    let container: Container

    init(_ container: Container) {
        self.container = container
    }

    func register<Type>(type: Type.Type, createdWith factory: InstanceFactory) -> DynamicInstanceScopeSelector<Type> {
        let dynamicServiceRegistration = DynamicInstanceRegistrationPrototype<Type>(factory: factory, scopeKey: container.key)
        registrationPrototypes.append(dynamicServiceRegistration)

        return DynamicInstanceScopeSelector<Type>(registrationPrototype: dynamicServiceRegistration)
    }

    /// Starts registration of an existing instance.
    ///
    /// For example:
    ///
    ///     let appleJuice = FreshJuice(Apple())
    ///     let container = try Container { builder in
    ///         builder.register(instance: appleJuice)
    ///             .ownedByContainer()
    ///             .asSelf()
    ///     }
    ///
    /// - Parameter instance: The instance to register. It must be the instance of a reference type i.e. class.
    /// - Returns: A specialized builder to complete component registration.
    public func register<Type: AnyObject>(instance: Type) -> ExternalInstanceOwnershipBuilder<Type> {
        let registrationPrototype = ExternalInstanceRegistrationPrototype(instance: instance)
        registrationPrototypes.append(registrationPrototype)
        return ExternalInstanceOwnershipBuilder<Type>(registrationPrototype)
    }

    /// Starts registration of a value.
    ///
    ///
    /// - Parameter value: The value to register.
    ///
    /// - Attention: Use this method to register instance of a value type.
    /// For reference type use `register(instance: Type)`.
    ///
    /// - Returns: A specialized builder to complete component registration.
    public func register<Type: Any>(value: Type) -> ValueRegistrationBuilder<Type> {
        let registrationPrototype = ValueRegistrationPrototype(value: value)
        registrationPrototypes.append(registrationPrototype)
        return ValueRegistrationBuilder<Type>(registrationPrototype: registrationPrototype)
    }

    /// Starts registration of a component factory.
    ///
    /// - Parameter factory: The factory that will produce an instance of component at runtime.
    /// - Parameter scope: A runtime resolution scope from which the `factory` can resolve parameters
    ///      for the component.
    ///
    /// - Returns: A specialized builder to complete component registration.
    public func register<Type>(factory: @escaping (_ scope: Scope) throws -> Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: Type.self, createdWith: DelegatingFactory(factory))
    }

    func build(_ buildFunc: (ContainerBuilder) -> Void) throws {
        buildFunc(self)

        for registrationPrototype in registrationPrototypes {
            let serviceRegistration: ServiceRegistration = try registrationPrototype.build()

            for serviceType in registrationPrototype.services {
                container.registrations[TypeKey(for: serviceType)] = serviceRegistration
            }
        }
    }
}

extension ContainerBuilder {
    /// Starts registration of an injectable component.
    ///
    /// - Parameter type: The type of component to registers.
    ///
    /// - Returns: Specialized builder to complete registration.
    public func register<Type: Injectable>(injectable type: Type.Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactory<Type>())
    }

    /// Starts registration of an injectable component.
    ///
    /// - Parameter type: The type of component to registers.
    ///
    /// - Returns: Specialized builder to complete registration.
    public func register<Type: InjectableWithParameter>(injectable type: Type.Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithParameter<Type>())
    }

    /// Starts registration of an injectable component.
    ///
    /// - Parameter type: The type of component to registers.
    ///
    /// - Returns: Specialized builder to complete registration.
    public func register<Type: InjectableWithTwoParameters>(injectable type: Type.Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithTwoParameters<Type>())
    }

    /// Starts registration of an injectable component.
    ///
    /// - Parameter type: The type of component to registers.
    ///
    /// - Returns: Specialized builder to complete registration.
    public func register<Type: InjectableWithThreeParameters>(injectable type: Type.Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithThreeParameters<Type>())
    }

    /// Starts registration of an injectable component.
    ///
    /// - Parameter type: The type of component to registers.
    ///
    /// - Returns: Specialized builder to complete registration.
    public func register<Type: InjectableWithFourParameters>(injectable type: Type.Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithFourParameters<Type>())
    }

    /// Starts registration of an injectable component.
    ///
    /// - Parameter type: The type of component to registers.
    ///
    /// - Returns: Specialized builder to complete registration.
    public func register<Type: InjectableWithFiveParameters>(injectable type: Type.Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithFiveParameters<Type>())
    }
}
