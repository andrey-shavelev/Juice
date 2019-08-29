//
// Created by Andrey Shavelev on 29/08/2019.
//

import Foundation

public class ValueRegistrationBuilder<Type> {
    let registrationPrototype: ValueRegistrationPrototype<Type>

    internal init(registrationPrototype: ValueRegistrationPrototype<Type>) {
        self.registrationPrototype = registrationPrototype
    }

    @discardableResult
    public func `as`<TService>(_ serviceType: TService.Type) -> ValueRegistrationBuilder<Type> {
        registrationPrototype.services.append(serviceType)
        return self
    }

    @discardableResult
    public func asSelf() -> ValueRegistrationBuilder<Type> {
        registrationPrototype.services.append(Type.self)
        return self
    }
}
