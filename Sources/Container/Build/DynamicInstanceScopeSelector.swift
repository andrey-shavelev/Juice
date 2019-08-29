//
//  ServiceScopeSelector.swift
//  blaze
//
//  Created by Andrey Shavelev on 17/06/2019.
//

import Foundation

public struct DynamicInstanceScopeSelector<Type> {
    let registrationPrototype: DynamicInstanceRegistrationPrototype<Type>

    internal init(registrationPrototype: DynamicInstanceRegistrationPrototype<Type>) {
        self.registrationPrototype = registrationPrototype
    }

    public func singleInstance() -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perScope(key: registrationPrototype.scopeKey)
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype)
    }

    public func instancePerDependency() -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perDependency
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype)
    }

    public func instancePerContainer() -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perScope(key: ScopeKey.any)
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype)
    }

    public func instancePerContainer(name: String) -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perScope(key: ScopeKey.named(name: name))
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype)
    }
}
