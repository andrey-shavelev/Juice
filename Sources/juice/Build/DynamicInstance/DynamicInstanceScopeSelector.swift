//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

public struct DynamicInstanceScopeSelector<Type> {
    let registrationPrototype: DynamicInstanceRegistrationPrototype<Type>

    internal init(registrationPrototype: DynamicInstanceRegistrationPrototype<Type>) {
        self.registrationPrototype = registrationPrototype
    }

    /// Sets sharing mode to Single Instance
    ///
    /// Only one instance at a time is created for such component.
    /// It is shared between all dependencies and all child containers.
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
    /// If you try to resolve `Juice` from `childContainer` or from `container` you will
    /// get the same instance. Resolving multiple times from same container will also
    /// give the same instance.
    ///
    /// - Note: Container keeps strong reference to such component.
    public func singleInstance() -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perScope(key: registrationPrototype.scopeKey)
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype)
    }

    /// Sets sharing mode to Instance Per Dependency
    ///
    /// A new instance of this component is created every time it is resolved from container,
    /// or injected as dependency.
    ///
    /// - Note: Container does not keep any reference to such components.
    public func instancePerDependency() -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perDependency
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype)
    }

    /// Sets sharing mode to Instance Per Container
    ///
    /// One instance of component is created and reused within container but not between child containers.
    /// Each child container creates its own instance of component when needed.
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
    ///     let childContainer = container.createChildContainer()
    ///
    /// If you try to resolve `Juice` from `childContainer` and from `container` you will
    /// get the same instance.
    /// However, resolving multiple times from same container will give the same instance.
    /// - Note: Container keeps strong reference to such component.
    public func instancePerContainer() -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perScope(key: ScopeKey.any)
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype)
    }

    /// Sets sharing mode to Instance Per Container
    ///
    /// One instance of this component is created withing a child container with specified `name`.
    /// This instance is reused for other containers derrived from named child container.
    ///
    /// For example:
    ///
    ///     let container = try Container {
    ///         $0.register(injectable: Orange.self)
    ///                 .instancePerDependency()
    ///                 .as(Fruit.self)
    ///         $0.register(injectable: FreshJuice.self)
    ///                 .instancePerContainer(name: "garder")
    ///                 .as(Juice.self)
    ///     }
    ///     let gardenScope = container.createChildContainer(name: "garder")
    ///     let zenScope = gardenScope.createChildContainer(name: "zen")
    ///     let innerGardenScope = zenScope.createChildContainer(name: "garden")
    ///
    /// Here `gardenScope` and `zenScope` will share the same instance of juice, but
    /// 'innerGardenScope' will have it's own.
    ///
    /// - Parameter name: The name of child container that will own instance of this component.
    /// - Note: Container keeps strong reference to such component.
    public func instancePerContainer(withName name: String) -> DynamicInstanceRegistrationBuilder<Type> {
        registrationPrototype.kind = .perScope(key: ScopeKey.named(name: name))
        return DynamicInstanceRegistrationBuilder(registrationPrototype: registrationPrototype)
    }
}
