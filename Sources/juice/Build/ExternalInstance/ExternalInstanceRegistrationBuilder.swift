//
// Copyright © 2019 Juice Project. All rights reserved.
//

public struct ExternalInstanceRegistrationBuilder<Type: AnyObject> {
    let registrationPrototype: ExternalInstanceRegistrationPrototype<Type>

    internal init(_ registrationPrototype: ExternalInstanceRegistrationPrototype<Type>) {
        self.registrationPrototype = registrationPrototype
    }

    /// Registers by a specific service.
    ///
    /// For example:
    ///
    ///     let container = try Container { builder in
    ///         builder.register(injectable: Apple.self)
    ///             .singleInstance()
    ///             .as(Fruit.self)
    ///
    ///     let fruit = try container.resolve(Fruit.self)
    ///
    /// - Prameter serviceType: The type of service that this component provides.
    ///
    @discardableResult
    public func `as`<TService>(_ serviceType: TService.Type) -> ExternalInstanceRegistrationBuilder<Type> {
        registrationPrototype.services.append(serviceType)
        return self
    }

    /// Registers component by its own type.
    ///
    /// For example:
    ///
    ///     let container = try Container { builder in
    ///         builder.register(injectable: Apple.self)
    ///             .singleInstance()
    ///             .asSelf()
    ///
    ///     let apple = try container.resolve(Apple.self)
    @discardableResult
    public func asSelf() -> ExternalInstanceRegistrationBuilder<Type> {
        registrationPrototype.services.append(Type.self)
        return self
    }
}
