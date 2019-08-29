//
//  StaticInstanceRegistrationBuilder.swift
//  blaze
//
//  Created by Andrey Shavelev on 20/06/2019.
//

public struct ExternalInstanceRegistrationBuilder<Type: AnyObject> {
    let registrationPrototype: ExternalInstanceRegistrationPrototype<Type>

    internal init(registrationPrototype: ExternalInstanceRegistrationPrototype<Type>) {
        self.registrationPrototype = registrationPrototype
    }

    @discardableResult
    public func `as`<TService>(_ serviceType: TService.Type) -> ExternalInstanceRegistrationBuilder<Type> {
        registrationPrototype.services.append(serviceType)
        return self
    }

    @discardableResult
    public func asSelf() -> ExternalInstanceRegistrationBuilder<Type> {
        registrationPrototype.services.append(Type.self)
        return self
    }

    @discardableResult
    public func ownedByContainer() -> ExternalInstanceRegistrationBuilder<Type> {
        registrationPrototype.ownedByContainer = true
        return self
    }
}
