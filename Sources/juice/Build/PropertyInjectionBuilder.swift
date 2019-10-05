//
// Copyright © 2019 Juice Project. All rights reserved.
//

public protocol PropertyInjectionBuilder {
    associatedtype BuilderType
    associatedtype ComponentType

    /// Tells the container to inject a dependency at a given `keyPath`
    ///
    /// For example:
    ///
    ///     class Jam: Injectable {
    ///         var fruit: Fruit!
    ///         var spice: Spice?
    ///
    ///         required init() {
    ///         }
    ///     }
    ///     let container = try Container { builder in
    ///         ...
    ///         builder.register(injectable: Jam.self)
    ///                 .singleInstance()
    ///                 .asSelf()
    ///                 .injectDependency(into: \.fruit)
    ///                 .injectOptionalDependency(into: \.spice)
    ///     }
    ///
    @discardableResult
    func injectDependency<PropertyType>(into keyPath: WritableKeyPath<ComponentType, PropertyType?>) -> BuilderType

    /// Tells the container to inject an optional dependency at given `keyPath`
    ///
    /// For example:
    ///
    ///     class Jam: Injectable {
    ///         var fruit: Fruit!
    ///         var spice: Spice?
    ///
    ///         required init() {
    ///         }
    ///     }
    ///     let container = try Container { builder in
    ///         ...
    ///         builder.register(injectable: Jam.self)
    ///                 .singleInstance()
    ///                 .asSelf()
    ///                 .injectDependency(into: \.fruit)
    ///                 .injectOptionalDependency(into: \.spice)
    ///     }
    ///
    @discardableResult
    func injectOptionalDependency<PropertyType>(into keyPath: WritableKeyPath<ComponentType, PropertyType?>) -> BuilderType
}