//
//  ContainerBuilder.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class ContainerBuilder {
    
    internal var registrations = [ServiceKey : ServiceRegistration]()
    
    func register<Type: Injectable>(type: Type.Type) -> TypeRegistrationBuilder {
        return register(type: type, with: InjectableImplementorFactory<Type>())
    }
    
    func register<Type: InjectableWithParameter>(type: Type.Type) -> TypeRegistrationBuilder {
        return register(type: type, with: InjectableImplementorFactoryWithParameter<Type>())
    }
    
    func register<Type>(type: Type.Type, with factory: InstanceFactory) -> TypeRegistrationBuilder {
        return TypeRegistrationBuilder(self, factory)
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
}
