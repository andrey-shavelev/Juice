//
//  ContainerBuilder.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class ContainerBuilder {
    
    internal var registrations = [ServiceKey : ServiceRegistration]()
    
    func register<Type>(type: Type.Type, with factory: InstanceFactory) -> TypeRegistrationBuilder {
        return TypeRegistrationBuilder(self, factory)
    }
    
    func register<Type: Injectable>(type: Type.Type) -> TypeRegistrationBuilder {
        return register(type: type, with: InjectableFactory<Type>())
    }
    
    func register<Type: InjectableWithParameter>(type: Type.Type) -> TypeRegistrationBuilder {
        return register(type: type, with: InjectableFactoryWithParameter<Type>())
    }
    
    func register<Type: InjectableWithTwoParameters>(type: Type.Type) -> TypeRegistrationBuilder {
        return register(type: type, with: InjectableFactoryWithTwoParameters<Type>())
    }
    
    func register<Type: InjectableWithThreeParameters>(type: Type.Type) -> TypeRegistrationBuilder {
        return register(type: type, with: InjectableFactoryWithThreeParameters<Type>())
    }
    
    func build() -> Container {
        return Container(registrations)
    }
}

extension ContainerBuilder {
    func register<Type: Injectable>(singleInstance: Type.Type) -> TypeRegistrationBuilder {
        return register(type: singleInstance).singleInstance()
    }
    
    func register<Type: InjectableWithParameter>(singleInstance: Type.Type) -> TypeRegistrationBuilder {
        return register(type: singleInstance).singleInstance()
    }
    
    func register<Type: InjectableWithTwoParameters>(singleInstance: Type.Type) -> TypeRegistrationBuilder {
        return register(type: singleInstance).singleInstance()
    }
}
