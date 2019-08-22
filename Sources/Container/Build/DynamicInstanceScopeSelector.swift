//
//  ServiceScopeSelector.swift
//  blaze
//
//  Created by Andrey Shavelev on 17/06/2019.
//

import Foundation

public struct DynamicInstanceScopeSelector<Type> {
    let builder: ContainerBuilder
    let registrationPrototype: DynamicInstanceRegistrationPrototype<Type>

    internal init(
            registrationPrototype: DynamicInstanceRegistrationPrototype<Type>,
            builder: ContainerBuilder) {
        self.registrationPrototype = registrationPrototype
        self.builder = builder
    }

    public func singleInstance() -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perScope(key: builder.scopeKey)
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype, builder: builder)
    }

    public func instancePerDependency() -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perDependency
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype, builder: builder)
    }

    public func instancePerContainer() -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perScope(key: ScopeKey.any)
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype, builder: builder)
    }

    public func instancePerContainer(name: String) -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perScope(key: ScopeKey.named(name: name))
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype, builder: builder)
    }
}
