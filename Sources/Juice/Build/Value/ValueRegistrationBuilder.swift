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
    public func `as`<Service>(_ serviceType: Service.Type) -> ValueRegistrationBuilder<Type> {
        registrationPrototype.services.append(ServiceKey(type: serviceType))
        return self
    }
    
    @discardableResult
    public func `as`<Service, Key: Hashable>(_ serviceType: Service.Type, withKey key: Key) -> ValueRegistrationBuilder<Type> {
        registrationPrototype.services.append(ServiceKey(type: serviceType, key: key))
        return self
    }

    @discardableResult
    public func asSelf() -> ValueRegistrationBuilder<Type> {
        return `as`(Type.self)
    }
}
