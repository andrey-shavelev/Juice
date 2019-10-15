//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

public struct DynamicInstanceLifetimeBuilder<Type> {
    let registrationPrototype: DynamicInstanceRegistrationPrototype<Type>

    internal init(registrationPrototype: DynamicInstanceRegistrationPrototype<Type>) {
        self.registrationPrototype = registrationPrototype
    }

    /// Registers the component as `Single Instance`.
    ///
    /// Only one instance of such component is created per `Container`,
    /// and it is also shared with child containers.
    ///
    /// For example:
    ///
    ///     let container = try Container {
    ///         $0.register(injectable: Orange.self)
    ///            .instancePerDependency()
    ///            .as(Fruit.self)
    ///         $0.register(injectable: FreshJuice.self)
    ///            .singleInstance()
    ///            .as(Juice.self)
    ///         }
    ///     let childContainer = container.createChildContainer()
    ///
    /// - Note: Container keeps a strong reference to a `Single Instance` component.
    ///
    public func singleInstance() -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perScope(key: registrationPrototype.scopeKey)
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype)
    }

    /// Registers the component as `Instance Per Dependency`
    ///
    /// `Container` will always create a new instance of such component
    /// when it needs to inject it as a dependency.
    ///
    /// - Note: Container does not keep any reference to `Instance Per Dependency` components.
    ///
    public func instancePerDependency() -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perDependency
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype)
    }

    /// Registers the component as `Instance Per Container`
    ///
    /// Only one instance of such component is created per `Container`.
    /// However, in contrast to `Single Instance`, each child container will create its own instance.
    ///
    /// For example:
    ///
    ///     let container = try Container {
    ///         $0.register(injectable: Orange.self)
    ///            .instancePerDependency()
    ///            .as(Fruit.self)
    ///         $0.register(injectable: FreshJuice.self)
    ///            .instancePerContainer()
    ///            .as(Juice.self)
    ///         }
    ///
    ///     let childContainer = container.createChildContainer()
    ///
    /// - Note: Container keeps a strong reference to an `Instance Per Container` component.
    ///
    public func instancePerContainer() -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perScope(key: ScopeKey.any)
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype)
    }

    /// Registers the component as `Instance Per Named Container`
    ///
    /// An instance of this component will be created only in a container with a matching `name`.
    /// It will be shared with its child containers.
    ///
    /// For example:
    ///
    ///     let container = try Container {
    ///         $0.register(injectable: Orange.self)
    ///                 .instancePerDependency()
    ///                 .as(Fruit.self)
    ///         $0.register(injectable: FreshJuice.self)
    ///                 .instancePerContainer(name: "garden")
    ///                 .as(Juice.self)
    ///     }
    ///     let gardenScope = container.createChildContainer(name: "garden")
    ///     let zenScope = gardenScope.createChildContainer(name: "zen")
    ///     let innerGardenScope = zenScope.createChildContainer(name: "garden")
    ///
    /// Here, the `gardenScope` and the `zenScope` will share the same instance of a juice, but
    /// the 'innerGardenScope' will have its own.
    ///
    /// - Parameter name: The name of a container that will own this component.
    /// - Note: Container keeps a strong reference to `Instance Per Named Container` components.
    ///
    public func instancePerContainer(withName name: String) -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perScope(key: ScopeKey.named(name: name))
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype)
    }
}
