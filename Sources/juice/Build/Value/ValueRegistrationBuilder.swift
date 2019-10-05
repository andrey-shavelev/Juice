//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

public class ValueRegistrationBuilder<Type>: ComponentServicesBuilder {
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
