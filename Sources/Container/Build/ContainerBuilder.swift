//
//  ContainerBuilder.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class ContainerBuilder {
    
    var registrationsDictionary = [TypeKey : ServiceRegistration]()
    var registrations = [ServiceRegistration]()
    let scopeKey: ScopeKey
    
    init(scopeKey: ScopeKey) {
        self.scopeKey = scopeKey
    }
    
    func register<Type>(type: Type.Type, createdWith factory: InstanceFactory) -> DynamicInstaceScopeSelector<Type> {
        
        let dynamicServiceRegistration = DynamicInstanceRegistration<Type>(factory: factory)
        registrations.append(dynamicServiceRegistration)
        
        return DynamicInstaceScopeSelector<Type>(serviceRegistration: dynamicServiceRegistration, builder: self)
    }
    
    public func register<Type: Injectable>(injectable type: Type.Type) -> DynamicInstaceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactory<Type>())
    }
    
    public func register<Type: InjectableWithParameter>(injectable type: Type.Type) -> DynamicInstaceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithParameter<Type>())
    }
    
    public func register<Type: InjectableWithTwoParameters>(injectable type: Type.Type) -> DynamicInstaceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithTwoParameters<Type>())
    }
    
    public func register<Type: InjectableWithThreeParameters>(injectable type: Type.Type) -> DynamicInstaceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithThreeParameters<Type>())
    }
    
    public func register<Type: InjectableWithFourParameters>(injectable type: Type.Type) -> DynamicInstaceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithFourParameters<Type>())
    }
    
    public func register<Type: InjectableWithFiveParameters>(injectable type: Type.Type) -> DynamicInstaceScopeSelector<Type> {
        return register(type: type, createdWith: InjectableFactoryWithFiveParameters<Type>())
    }
    
    public func register<Type: CustomInjectable>(injectable type: Type.Type) -> DynamicInstaceScopeSelector<Type> {
        return register(type: type, createdWith: CustomInjectableFactory<Type>())
    }
    
    public func register<Type>(instance: Type) -> StaticInstanceRegistrationBuilder<Type> {
        let staticInstanceRegistration = StaticInstanceRegistration(instance: instance)
        registrations.append(staticInstanceRegistration)
        
        return StaticInstanceRegistrationBuilder<Type>(
            serviceRegistration: staticInstanceRegistration,
            builder: self)
    }
    
    public func register<Type>(autofactoryFor type: Type.Type) {
        register(injectable: Factory<Type>.self)
            .instancePerDependency()
            .asSelf()
    }
    
    func register<Type>(factory: @escaping (Scope) -> Type) -> DynamicInstaceScopeSelector<Type> {
        return register(type: Type.self, createdWith: DelegatingFactory(factory))
    }
    
    func build(_ buildFunc: (ContainerBuilder) -> Void) -> [TypeKey : ServiceRegistration] {
        buildFunc(self)
        return registrationsDictionary
    }
}
