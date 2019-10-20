# Juice
Juice is a Swift dependency injection container.

## Quick Start

Using Juice is simple. First, you create a Container and register required components. Second, resolve the services you need, while Juice injects all the dependencies automatically.

###  Creating a Container

Container builder has clear and fluent interface. Components are registered one by one, with all options specified explicitly:

```swift
let container = try Container { builder in
    builder.register(injectable: FreshJuice.self)
            .instancePerDependency()
            .as(Juice.self)
    builder.register(injectable: Orange.self)
            .instancePerDependency()
            .as(Fruit.self)
            .asSelf()
}
```

Where _FreshJuice_ and _Orange_ could be defined as:

```swift
class FreshJuice: InjectableWithParameter {
    let fruit: Fruit

    required init(_ fruit: Fruit) {
        self.fruit = fruit
    }
}

protocol Fruit {
}

class Orange: Fruit, Injectable {
    required init() {
    }
}
```

### Resolving a Service

You resolve a service from the container by calling _resolve(…)_ method:

```swift
let orangeJuice = try container.resolve(Juice.self)
```

Or optional service _resolveOptional(…)_:

```swift
let compot = try container.resolveOptional(Compot.self)
let tea = try container.resolve(Tea?.self)
```

#### Resolving with Arguments

You can pass additional arguments to a component:

```swift
let appleJuice = try container.resolve(Juice.self, withArguments: Argument<Fruit>(Apple.self))
```

Arguments are used both: to inject dependencies into _init(…)_ method and for the property injection.

### Property Injection

#### Using Writable Key Paths

When registering a component, you may specify properties that Container will use to  inject dependencies.

```swift
let container = try Container { builder in
    builder.register(injectable: Pear.self)
            .singleInstance()
            .as(Fruit.self)
    builder.register(injectable: Ginger.self)
            .singleInstance()
            .as(Spice.self)
    builder.register(injectable: Jam.self)
            .singleInstance()
            .asSelf()
            .injectDependency(into: \.fruit)
            .injectDependency(into: \.spice)
}

class Jam: Injectable {
    var fruit: Fruit!
    var spice: Spice?

    required init() {
    }
}
```

#### Using Property Wrappers

Dependencies could also be injected using _@Inject_ property wrapper.

```swift
let container = try Container { builder in
    builder.register(injectable: Pear.self)
            .singleInstance()
            .as(Fruit.self)
    builder.register(injectable: Ginger.self)
            .singleInstance()
            .as(Spice.self)
    builder.register(injectable: Jam.self)
            .singleInstance()
            .asSelf()
}

class Jam: Injectable {
    @Inject var fruit: Fruit
    @Inject var spice: Spice?

    required init() {
    }
}
```

### Child Containers

```swift
let container = try Container {
    $0.register(injectable: Orange.self)
            .instancePerDependency()
            .as(Fruit.self)
    $0.register(injectable: FreshJuice.self)
            .instancePerDependency()
            .asSelf()
}
let childContainer = try container.createChildContainer {
    $0.register(injectable: Apple.self)
            .instancePerDependency()
            .as(Fruit.self)
}

let appleJuice = try childContainer.resolve(FreshJuice.self)
```

A child container keeps a reference to its parent and inherits all component registrations from it. Parent container does not keep any reference to child container, and your code is fully responsible for managing its lifetime.

### Thread Safety

Thread safety is not implemented yet. All access to the container from multiple threads must be synchronized by calling code.

## More Details

### Container build

#### Components and Services

A _component_ is a type registered in the container during the build phase, whereas a _service_ is a type that is later resolved from the container as a dependency or by calling _resolve(…)_ method. A service, for example, might be represented by a protocol that the component conforms to, or it could be component’s type itself. 
One component may be registered by several services. In contrast, you can not register two or more components by the same service in one container. This is not supported at the moment. However, you can override registration of a service using a child container.
For example:

```swift
let container = try Container { builder in
    builder.register(injectable: FreshJuice.self)
            .instancePerDependency()
            .as(Juice.self)
    builder.register(injectable: Orange.self)
            .instancePerDependency()
            .as(Fruit.self)
            .asSelf()
}

let childContainer = try container.createChildContainer { builder in
    builder.register(injectable: Apple.self)
        .instancePerDependency()
        .as(Fruit.self)
}

let orangeJuice = container.resolve(Juice.self)
let appleJuice = childContainer.resolve(Juice.self)
let orange = childContainer.resolve(Orange.self)
```

FreshJuice, Orange and Apple are components, while Juice and Fruit are services that they provide. 
When you resolve Juice from child container Apple is by injected as Fruit, however, when resolved from parent container, Juice receives Orange for its dependency. Orange could also be resolved by its own type from child container.

#### The Injectable Protocol

Juice needs to know how to create an instance of a component when it is resolved. The simplest way to tell the container how to do it, is to conform your component to the _Injectable_ protocol.

```swift
builder.register(injectable: Orange.self)
```

```swift
public protocol Injectable {
    init()
}
```

The Injectable protocol has only one member: the required _init()_ method without any parameters. When the component has dependencies, you can conform it to one of the InjectableWithParameter protocols, depending on how many parameters that _init(…)_ method has.

```swift
public protocol InjectableWithParameter {
    associatedtype ParameterType
    init(_ parameter: ParameterType)
}
// or
public protocol InjectableWithTwoParameters {
    associatedtype FirstParameterType
    associatedtype SecondParameterType

    init(_ firstParameter: FirstParameterType, _ secondParameter: SecondParameterType)
}
public typealias InjectableWith2Parameters = InjectableWithTwoParameters
// etc.
```

Alternatively, or when a component has too many dependencies, you can inject _CurrentScope_ protocol and resolve everything manually:

```swift
class TeaBlend: InjectableWithParameter {
    let tea: Tea
    let fruit: Fruit
    let berry: Berry
    let flower: Flower
    let herb: Herb
    let spice: Spice

    required init(_ scope: CurrentScope) throws {
        self.tea = try scope.resolve(Tea.self)
        self.fruit = try scope.resolve(Fruit.self)
        self.berry = try scope.resolve(Berry.self)
        self.flower = try scope.resolve(Flower.self)
        self.herb = try scope.resolve(Herb.self)
        self.spice = try scope.resolve(Spice.self)
    }
}
```

CurrentScope is a protocol that represents a scope that the component is resolved from. Behind CurrentScope could be a simple container wrapper or a parameterized container wrapper that holds additional arguments.
Your component may keep a reference to CurrentScope to resolve dependencies later on. It supposed that components have the same or shorter lifetime then the container, so keeping reference to CurrentScope should not be a problem. However, CurrentScope itself keeps a weak reference to the container. It means that if a component is designed to have a longer lifetime than the container, CurrentScope may become invalid and will throw an error if you try to resolve services from it. If this is the case, you need to check the _.isValid_ property of CurrentScope to determine if it still valid.

##### Creating a Child Container from a Component.

CurrentScope could also be used to create a child container, using on of the _createChildContainer_ methods. Please note, that additional arguments that might be present in the CurrentScope are not inherited buy child containers, only component registrations are.

#### Property Injection

Using property injection, unlike conforming to InjectableWithParameter protocol, does not require you to update protocol conformance each time you add or remove a dependency. However, you should keep in mind some limitations that it imposes: 

1. When using writeable keypaths, all properties that dependencies are injected into must be declared optional or implicitly unwrapped optional, and could not be private. Also, please note, that simply declaring your property optional, does not tell Juice that it needs to inject an optional dependency into it. For that you need to use _.injectOptionalDependency(into:)_ method, while building the component registration.
2. @Inject wrapper allow you to inject properties even in the private properties, and declaring property as optional does what it is supposed to do: Juice will search for an optional registration and, if not found, will set the value to _nil_. However, classes and structures that use the @Inject wrapper can not be simply created by calling _init_ method, they can only be resolved from the container. Creating them in a traditional way will cause a runtime error.

In any case dependencies will be injected into properties immediately after _init(…)_ method has finished; the instance of the component will not be accessible to other parts of you program until then.

#### Registering a Component Factory

In cases when conformance to the Injectable protocol is not possible or not desired, you can also register a factory closure that will be used to create instances of the component when needed.

```swift
let container = try Container { builder in
    builder.register(factory: {
        Cocktail(fruitJuice: try $0.resolve(Juice.self), 
            lime: Lime(), 
            sweetener: Sugar(), 
            water: SodaWater())})
            .singleInstance()
            .asSelf()
}

class Cocktail {
    let fruitJuice: Juice
    let lime: Lime
    let sweetener: Sweetener
    let water: Water

    required init(fruitJuice: Juice,
                  lime: Lime,
                  sweetener: Sweetener,
                  water: Water) {
        self.fruitJuice = fruitJuice
        self.lime = lime
        self.sweetener = sweetener
        self.water = water
    }
}
```

A factory closure receives a single parameter: _Scope_ that should be used to resolve required dependencies.

#### External Instances

You can register an external instance, i.e. an instance that was created before the container and possibly has a longer lifetime. When registering such instance, you may optionally tell container to take ownership and keep a strong reference to it.

```swift
let apple = Apple()
        
let container = try Container { builder in
    builder.register(instance: apple)
            .ownedByContainer()
            .asSelf()
```

#### Component Lifetime

For every component that will be created at runtime by container, you need to specify if there will be only one instance of it, or the container has to create a new instance each time when the component is injected as a dependency or _resolve(…)_ method is called. That makes two different groups of components: _single instance_ and _instance per dependency_.  
Juice keeps a strong reference to all single instance components that were created during the container lifetime. And it is supposed that they are deallocated together with the owning container. 
No reference is kept to instance per dependency components, and the user code is responsible for managing their lifetime.

Single instance components are shared between all child containers. If this does not suite your needs, there are two more options available:

1. _Instance per container_ components are similar to single instance, but are not shared between child containers and each of them will create its own instance.
2. _Instance per named container_ components. Same as previous, but component are only created within containers with matching name. 

### Dependency Injection

Juice automatically resolves and injects all the dependencies when it creates an instance. With a single container the process is trivial. If you use child containers, algorithm is a little bit more tricky, but still could be described with a three simple steps:
1. First, Juice looks for a matching component registration, going from the current container and up in the hierarchy.
2. When a registration is found, Juice returns to the child container, and repeats the process, but looking for a correct place to create and store the component.
3. Finally, after it finds the matching storage, Juice resolves all component dependencies from it, and then creates an instance and, if needed, stores it in the container.

Consider this example:

```swift
let rootContainer = try Container { builder in
    builder.register(injectable: ComponentA.self)
        .instancePerDependency()
        .as(ServiceA.self)
    builder.register(injectable: ComponentB.self)
        .singleInstance()
        .as(ServiceB.self)
    builder.register(injectable: ComponentC.self)
        .instancePerContainer()
        .as(ServiceC.self)
    builder.register(injectable: ComponentD.self)
        .instancePerContainer(withName: "branch")
        .as(ServiceD.self)
    // ... some other registrations
}

let branchContainer = rootContainer.createChildContainer(name: "branch")

let leafContainer = try branchContainer.createChildContainer { builder in
    builder.register(injectable: ComponentX.self)
        .singleInstance()
        .asSelf()
}

var componentX = try leafContainer.resolve(ComponentX.self)
```

ComponentX is the single instance component, so it will be created and stored in the leafContainer, where it was registered. Let’s say, it also requires ServiceA, SerivceB, SerivceC and ServiceD, so before the instance of ComponentX is created Juice needs to resolve all of them. ComponentA is the instance per dependency component, so it will be created within the same leafContainer. It will not be stored there, but it will receive all its dependencies from it. ComponentB , as a single instance component, will be created in rootContainer. An instance of ComponentC, in its turn, will be created and stored in leafContainer, while ComponentD will be created in branchContainer.

#### Injecting an optional dependency

A service is considered optional, if it is unknown if it is registered in the container or not. There are several way to resolve an optional service.

Like this:
```swift
struct SushiRoll: Injectable {
    // Required stuff
    @Inject var tuna: Tuna
    @Inject var cucumber: Cucumber
    @Inject var mayo: Mayo
    // Really optional
    @Inject var omelette: Omelette?   
}
```

Or like this:
```swift
class SushiRoll: InjectableWithParameter {
    required init(_ currentScope: CurrentScope) throws {
        self.omelette = try currentScope.resolveOptional(Omlet.self)
        // ...
    }
    // ...
}
```

Or like this:
```swift
class SushiRoll: InjectableWithParameter {
    required init(_ currentScope: CurrentScope) throws {
        self.omelette = try currentScope.resolve(Omelette?.self)
        // ...
    }
    // ...
}
```

Or like this:
```swift
class SushiRoll: InjectableWith4Parameters {    
    required init(_ tuna: Tuna,
                  _ cucumber: Cucumber,
                  _ majo: Majo,
                  _ optionalOmelette: Omelette?) {
        // ...
    }
}
```

Either way, Juice will resolve an Omelette if it is registered or will put/return _nil_ if it is not.

There is one more situation to consider:
```swift
class FreshJuice: InjectableWithParameter, Juice {
    let fruit: Fruit

    required init(_ fruit: Fruit) {
        self.fruit = fruit
    }
}

// ...

let container = try Container { builder in
            builder.register(injectable: FreshJuice.self)
                .instancePerDependency()
                .as(Juice.self)
        }

let freshJuice = try container.resolveOptional(Juice.self)
```

In the example above _freshJuice_ is not set to _nil_. An error is thrown instead. That happens, because Container holds a correct registration of FreshJuice component that provides Juice service, however FreshJuice itself has a missing dependency. Fruit is not registered in container. This situation is treated as a mistake in the configuration, Container does not try to hide it and, instead, reports an error.
Summarizing, Container uses following schema, when resolving an optional service:

1. Search for a registration. If not found - return nil. If found go to step 2.
2. Try to resolve registered component. Registered successfully? Return an instance of component, else throw an error.

#### Providing additional arguments to a component

You can pass additional arguments, including specific dependencies, when resolving a component. For example:

```swift
let appleJuice = try container.resolve(Juice.self, withArguments: Argument<Fruit>(Apple.self))
```

All arguments are added to the _CurrentScope_ of resolved component, and are used both to inject parameters to _init_ method, and for the property injection. For components registered as _single instance_, or _instance per container_, only  first call to `container.resolve(Service.self, withArguments: ...)` actually will have an effect. Subsequent calls will return existing instance, and all arguments will be ignored.
Please note that if a component keeps a reference to its CurrentScope, then it also creates a references to all arguments in it, if any were passed.

## Fail-fast

Juice follows [Fail-fast](https://en.wikipedia.org/wiki/Fail-fast) principle and it throws a _ContainerError_ when it can not find required dependencies, when a component registration is incomplete or incorrect or when any other possibly erroneous situation occurs.

## Roadmap to Version 1.0

1. Modules.
2. Thread safety.
3. Defered resolution of dependencies with Defered\<T\>. @Inject(.deferred)
4. AutoFactory\<T\> – to simplify creating multiple child components with arguments.
5. Dynamic registrations.
6. Weak references to a single instance component.
7. Allow multiple components implementing the same service.

## License

This project is licensed under MIT License.
