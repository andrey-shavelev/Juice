//
// Copyright © 2019 Juice Project. All rights reserved.
//

/// Builds all registrations within a `Container`.
///
public class ContainerBuilder {
    var registrationPrototypes = [RegistrationPrototype]()
    let container: Container

    init(_ container: Container) {
        self.container = container
    }

    func register<Type>(type: Type.Type, createdWith factory: InstanceFactory) -> DynamicInstanceLifetimeBuilder<Type> {
        let dynamicServiceRegistration = DynamicInstanceRegistrationPrototype<Type>(factory: factory, scopeKey: container.key)
        registrationPrototypes.append(dynamicServiceRegistration)

        return DynamicInstanceLifetimeBuilder<Type>(registrationPrototype: dynamicServiceRegistration)
    }

    /// Begins registration of an existing instance.
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
    ///
    public func register<Type: AnyObject>(instance: Type) -> ExternalInstanceOwnershipBuilder<Type> {
        let registrationPrototype = ExternalInstanceRegistrationPrototype(instance: instance)
        registrationPrototypes.append(registrationPrototype)
        return ExternalInstanceOwnershipBuilder<Type>(registrationPrototype)
    }

    /// Begins registration of a value.
    ///
    /// - Parameter value: The value to register.
    ///
    /// Use this method to register instance of a value type.
    /// For reference type use `register(instance: Type)`.
    ///
    public func register<Type: Any>(value: Type) -> ValueRegistrationBuilder<Type> {
        let registrationPrototype = ValueRegistrationPrototype(value: value)
        registrationPrototypes.append(registrationPrototype)
        return ValueRegistrationBuilder<Type>(registrationPrototype: registrationPrototype)
    }

    /// Begins registration of a component factory.
    ///
    /// - Parameter factory: The factory that will produce an instance of component at runtime.
    /// - Parameter scope: A scope from which the `factory` can resolve required dependencies.
    ///
    public func register<Type>(factory: @escaping (_ scope: Scope) throws -> Type) -> DynamicInstanceLifetimeBuilder<Type> {
        return register(type: Type.self, createdWith: DelegatingFactory(factory))
    }
    
    /// Registers a module
    ///
    /// - Parameter module: a module to register
    ///
    public func register(module: Module) {
        module.registerServices(into: self)
    }

    func build(_ buildFunc: (ContainerBuilder) -> Void) throws {
        buildFunc(self)

        for registrationPrototype in registrationPrototypes {
            let serviceRegistration: ServiceRegistration = try registrationPrototype.build()

            for serviceType in registrationPrototype.services {
                container.registrations[ComponentKey(for: serviceType)] = serviceRegistration
            }
        }
    }
}

extension ContainerBuilder {
    /// Begins registration of an injectable component.
    ///
    /// - Parameter type: The type of component to registers.
    ///
    public func register<Type: Injectable>(injectable type: Type.Type) -> DynamicInstanceLifetimeBuilder<Type> {
        return register(type: type, createdWith: InjectableFactory<Type>())
    }

    /// Begins registration of an injectable component.
    ///
    /// - Parameter type: The type of component to registers.
    ///
    public func register<Type: InjectableWithParameter>(injectable type: Type.Type) -> DynamicInstanceLifetimeBuilder<Type> {
        return register(type: type, createdWith: InjectableFactoryWithParameter<Type>())
    }

    /// Begins registration of an injectable component.
    ///
    /// - Parameter type: The type of component to registers.
    ///
    public func register<Type: InjectableWithTwoParameters>(injectable type: Type.Type) -> DynamicInstanceLifetimeBuilder<Type> {
        return register(type: type, createdWith: InjectableFactoryWithTwoParameters<Type>())
    }

    /// Begins registration of an injectable component.
    ///
    /// - Parameter type: The type of component to registers.
    ///
    public func register<Type: InjectableWithThreeParameters>(injectable type: Type.Type) -> DynamicInstanceLifetimeBuilder<Type> {
        return register(type: type, createdWith: InjectableFactoryWithThreeParameters<Type>())
    }

    /// Begins registration of an injectable component.
    ///
    /// - Parameter type: The type of component to registers.
    ///
    public func register<Type: InjectableWithFourParameters>(injectable type: Type.Type) -> DynamicInstanceLifetimeBuilder<Type> {
        return register(type: type, createdWith: InjectableFactoryWithFourParameters<Type>())
    }

    /// Begins registration of an injectable component.
    ///
    /// - Parameter type: The type of component to registers.
    ///
    public func register<Type: InjectableWithFiveParameters>(injectable type: Type.Type) -> DynamicInstanceLifetimeBuilder<Type> {
        return register(type: type, createdWith: InjectableFactoryWithFiveParameters<Type>())
    }
}
