//
//  ContainerBuilder.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class ContainerBuilder {
    
    internal var registrations = [ServiceKey : ServiceRegistration]()
    
    func register<TImplementor: Injectable>(type: TImplementor.Type) -> RegistrationBuilder<TImplementor> {
        return RegistrationBuilder(self)
    }
    
    func register<TImplementor: InjectableWithParameter>(type: TImplementor.Type) -> RegistrationBuilderWithParameter<TImplementor> {
        
        return RegistrationBuilderWithParameter(self)
    }
    
    func build() -> Container {
        return Container(registrations)
    }
}
