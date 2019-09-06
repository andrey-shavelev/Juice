//
//  ContainerBuilder.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class ContainerBuilder {

    var registrationPrototypes = [ServiceRegistrationPrototype]()
    let scopeKey: ScopeKey

    init(scopeKey: ScopeKey) {
        self.scopeKey = scopeKey
    }

    func register<Type>(type: Type.Type, createdWith factory: InstanceFactory) -> DynamicInstanceScopeSelector<Type> {
        let dynamicServiceRegistration = DynamicInstanceRegistrationPrototype<Type>(factory: factory, scopeKey: scopeKey)
        registrationPrototypes.append(dynamicServiceRegistration)

        return DynamicInstanceScopeSelector<Type>(registrationPrototype: dynamicServiceRegistration)
    }

    public func register<Type: AnyObject>(instance: Type) -> ExternalInstanceRegistrationBuilder<Type> {
        let registrationPrototype = ExternalInstanceRegistrationPrototype(instance: instance)
        registrationPrototypes.append(registrationPrototype)
        return ExternalInstanceRegistrationBuilder<Type>(registrationPrototype: registrationPrototype)
    }

    public func register<Type: Any>(value: Type) -> ValueRegistrationBuilder<Type> {
        let registrationPrototype = ValueRegistrationPrototype(value: value)
        registrationPrototypes.append(registrationPrototype)
        return ValueRegistrationBuilder<Type>(registrationPrototype: registrationPrototype)
    }

    func register<Type>(factory: @escaping (Scope) -> Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: Type.self, createdWith: DelegatingFactory(factory))
    }

    func build(_ buildFunc: (ContainerBuilder) -> Void) throws -> [TypeKey: ServiceRegistration] {
        buildFunc(self)

        var registrations = [TypeKey: ServiceRegistration]()

        for registrationPrototype in registrationPrototypes {
            let serviceRegistration: ServiceRegistration = try registrationPrototype.build()

            for serviceType in registrationPrototype.services {
                registrations[TypeKey(for: serviceType)] = serviceRegistration
            }
        }

        return registrations
    }
}

extension ContainerBuilder {
    public func register<Type: Injectable>(injectable type: Type.Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactory<Type>())
    }

    public func register<Type: InjectableWithParameter>(injectable type: Type.Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithParameter<Type>())
    }

    public func register<Type: InjectableWithTwoParameters>(injectable type: Type.Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithTwoParameters<Type>())
    }

    public func register<Type: InjectableWithThreeParameters>(injectable type: Type.Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithThreeParameters<Type>())
    }

    public func register<Type: InjectableWithFourParameters>(injectable type: Type.Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithFourParameters<Type>())
    }

    public func register<Type: InjectableWithFiveParameters>(injectable type: Type.Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithFiveParameters<Type>())
    }

    public func register<Type: CustomInjectable>(injectable type: Type.Type) -> DynamicInstanceScopeSelector<Type> {
        return register(type: type, createdWith: CustomInjectableFactory<Type>())
    }
}