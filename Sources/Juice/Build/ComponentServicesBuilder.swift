//
// Copyright © 2019 Juice Project. All rights reserved.
//

public protocol ComponentServicesBuilder {
    associatedtype BuilderType

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
    func `as`<TService>(_ serviceType: TService.Type) -> BuilderType

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
    ///
    @discardableResult
    func asSelf() -> BuilderType
}