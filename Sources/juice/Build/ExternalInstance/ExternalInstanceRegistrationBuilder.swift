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
    public func `as`<TService>(_ serviceType: TService.Type) -> ExternalInstanceRegistrationBuilder<Type> {
        prototype.services.append(serviceType)
        return self
    }

    @discardableResult
    public func asSelf() -> ExternalInstanceRegistrationBuilder<Type> {
        prototype.services.append(Type.self)
        return self
    }
}
