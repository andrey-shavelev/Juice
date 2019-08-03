//
//  ServiceScopeSelector.swift
//  blaze
//
//  Created by Andrey Shavelev on 17/06/2019.
//

import Foundation

public struct DynamicInstaceScopeSelector<Type> {
    let builder: ContainerBuilder
    let serviceRegistration: DynamicInstanceRegistration<Type>
    
    internal init(
        serviceRegistration: DynamicInstanceRegistration<Type>,
        builder: ContainerBuilder) {
        self.serviceRegistration = serviceRegistration
        self.builder = builder
    }
    
    public func singleInstance() -> DynamicInstanceRegistrationBuilder<Type> {
        serviceRegistration.kind = .perScope(key: builder.scopeKey)
        return DynamicInstanceRegistrationBuilder(serviceRegistration: serviceRegistration, builder: builder)
    }
    
    public func instancePerDependency() -> DynamicInstanceRegistrationBuilder<Type> {
        serviceRegistration.kind = .perDependency
        return DynamicInstanceRegistrationBuilder(serviceRegistration: serviceRegistration, builder: builder)
    }
    
    public func instancePerContainer() -> DynamicInstanceRegistrationBuilder<Type> {
        serviceRegistration.kind = .perScope(key: ScopeKey.any)
        return DynamicInstanceRegistrationBuilder(serviceRegistration: serviceRegistration, builder: builder)
    }

    public func instancePerContainer(name: String) -> DynamicInstanceRegistrationBuilder<Type> {
        serviceRegistration.kind = .perScope(key: ScopeKey.named(name: name))
        return DynamicInstanceRegistrationBuilder(serviceRegistration: serviceRegistration, builder: builder)
    }
}
