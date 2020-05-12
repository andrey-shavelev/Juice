//
// Copyright © 2019 Juice Project. All rights reserved.
//

public struct ExternalInstanceRegistrationBuilder<Type: AnyObject> : ComponentServicesBuilder {
    typealias Component = Type
    var prototype: ExternalInstanceRegistrationPrototype<Type>

    internal init(_ registrationPrototype: ExternalInstanceRegistrationPrototype<Type>) {
        self.prototype = registrationPrototype
    }

    @discardableResult
    public func `as`<Service>(_ serviceType: Service.Type) -> ExternalInstanceRegistrationBuilder<Type> {
        prototype.services.append(ServiceKey(type: serviceType))
        return self
    }
    
    @discardableResult
    public func `as`<Service, Key: Hashable>(_ serviceType: Service.Type, withKey key: Key) -> ExternalInstanceRegistrationBuilder<Type> {
        prototype.services.append(ServiceKey(type: serviceType, key: key))
        return self
    }

    @discardableResult
    public func asSelf() -> ExternalInstanceRegistrationBuilder<Type> {
        return `as`(Type.self)
    }
}
