//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

public class ValueRegistrationBuilder<Type> {
    
    let registrationPrototype: ValueRegistrationPrototype<Type>

    internal init(registrationPrototype: ValueRegistrationPrototype<Type>) {
        self.registrationPrototype = registrationPrototype
    }

    /// Registers the component by a `serviceType`.
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
    /// - Parameter serviceType: The type of a service that this component provides.
    ///
    @discardableResult
    public func `as`<TService>(_ serviceType: TService.Type) -> ValueRegistrationBuilder<Type> {
        registrationPrototype.services.append(serviceType)
        return self
    }

    /// Registers the component by its own type.
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
    public func asSelf() -> ValueRegistrationBuilder<Type> {
        registrationPrototype.services.append(Type.self)
        return self
    }
}
