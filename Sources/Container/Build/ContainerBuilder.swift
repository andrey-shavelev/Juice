//
//  ContainerBuilder.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class ContainerBuilder {
    
    var registrationsDictionary = [TypeKey : ServiceRegistration]()
    var registrations = [ServiceRegistration]()
    
    func register<Type>(type: Type.Type, createdWith factory: InstanceFactory) -> TypeRegistrationBuilder<Type> {
        let typedServiceRegistration = TypedServiceRegistration(factory: factory)
        registrations.append(typedServiceRegistration)
        return TypeRegistrationBuilder<Type>(
            serverRegistration: typedServiceRegistration,
            builder: self)
    }
    
    func register<Type: Injectable>(type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type, createdWith: InjectableFactory<Type>())
    }
    
    func register<Type: InjectableWithParameter>(type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type, createdWith: InjectableFactoryWithParameter<Type>())
    }
    
    func register<Type: InjectableWithTwoParameters>(type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type, createdWith: InjectableFactoryWithTwoParameters<Type>())
    }
    
    func register<Type: InjectableWithThreeParameters>(type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type, createdWith: InjectableFactoryWithThreeParameters<Type>())
    }
    
    func register<Type: InjectableWithFourParameters>(type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type, createdWith: InjectableFactoryWithFourParameters<Type>())
    }
    
    func register<Type: InjectableWithFiveParameters>(type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type, createdWith: InjectableFactoryWithFiveParameters<Type>())
    }
    
    func register<Type: CustomInjectable>(type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type, createdWith: CustomInjectableFactory<Type>())
    }
    
    func build() -> Container {
        return Container(registrationsDictionary)
    }
}

extension ContainerBuilder {
    
    @discardableResult
    func register<Type: Injectable>(singleInstance type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type).singleInstance()
    }
    
    @discardableResult
    func register<Type: InjectableWithParameter>(singleInstance type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type).singleInstance()
    }
    
    @discardableResult
    func register<Type: InjectableWithTwoParameters>(singleInstance type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type).singleInstance()
    }

    @discardableResult
    func register<Type: InjectableWithThreeParameters>(singleInstance type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type).singleInstance()
    }
    
    @discardableResult
    func register<Type: InjectableWithFourParameters>(singleInstance type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type).singleInstance()
    }
    
    @discardableResult
    func register<Type: InjectableWithFiveParameters>(singleInstance type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type).singleInstance()
    }
    
    @discardableResult
    func register<Type: CustomInjectable>(singleInstance type: Type.Type) -> TypeRegistrationBuilder<Type> {
        return register(type: type).singleInstance()
    }
    
}
